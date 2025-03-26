//These are the resources in the EC2 section of the AWS Console

//---------------------------------------------------------
// Instances
//---------------------------------------------------------

resource "aws_instance" "webserver" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  //Provides an EC2 instance resource. This allows instances to be created, updated, and deleted. 
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  subnet_id                   = data.aws_subnet.public-1a.id
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  vpc_security_group_ids      = [aws_security_group.sg-ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.iam_profile.name

  tags = {
    Name = "WebServer"
  }

  //Added this to make sure the DynamoDB table is created before the EC2
  //That way the user_data.sh script can populate records in the table
  # depends_on = [aws_dynamodb_table.db_table]
}

//---------------------------------------------------------
// Security Groups
//---------------------------------------------------------

resource "aws_default_security_group" "default" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
  //Provides a resource to manage a default security group. 
  vpc_id = data.aws_vpc.main.id
  //As a best practice, we delete all inbound rules from the default security group
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg-alb" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  //Provides a security group resource.
  description = "Inbound access for ALB"
  name        = "alb_sg"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    //Allow port 80 from the AWS Workspace
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    //Allow port 9090 from the AWS Workspace
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    //Allow all outbound traffic. Outbound traffic is normally not restricted. 
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group" "sg-ec2" {
  description = "Inbound access for EC2"
  name        = "ec2_sg"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    //Allow port 80 from the Load Balancer (specifically from the Load Balancer security group)
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-alb.id]
  }
  ingress {
    //Allow port 9090 from the Load Balancer (specifically from the Load Balancer security group)
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-alb.id]
  }
  ingress {
    //Allow port 80 from the AWS Workspace
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    //Allow port 9090 from the AWS Workspace
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    //Allow all outbound traffic. Outbound traffic is normally not restricted. 
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2_sg"
  }
}

//---------------------------------------------------------
// Target Groups
//---------------------------------------------------------

resource "aws_lb_target_group" "TG80" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
  //Provides a Target Group resource for use with Load Balancer resources.
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  target_type = "instance"

  health_check {
    //We set these because the defaults take too long to recognize a target is availabile
    enabled           = true
    healthy_threshold = 2
    interval          = 10
    timeout           = 6
  }
}

resource "aws_lb_target_group_attachment" "LB_attach_80" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
  //Provides the ability to register instances and containers with an Application Load Balancer (ALB) target group.
  target_group_arn = aws_lb_target_group.TG80.arn
  //Register our EC2 instance as a target for the group
  target_id = aws_instance.webserver.id
}

resource "aws_lb_target_group" "TG9090" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
  //Provides a Target Group resource for use with Load Balancer resources.

  port     = 9090
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  target_type = "instance"

  health_check {
    //We set these because the defaults take too long to recognize a target is availabile
    enabled           = true
    healthy_threshold = 2
    interval          = 10
    timeout           = 6
  }
}

resource "aws_lb_target_group_attachment" "LB_attach_9090" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
  //Provides the ability to register instances and containers with an Application Load Balancer (ALB) target group.
  target_group_arn = aws_lb_target_group.TG9090.arn
  //Register our EC2 instance as a target for the group
  target_id = aws_instance.webserver.id
}

//---------------------------------------------------------
// Load Balancers
//---------------------------------------------------------

resource "aws_lb" "alb" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
  //Provides a Load Balancer resource.
  name               = "WebServer-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [for subnet in data.aws_subnet.public : subnet.id]

}

resource "aws_lb_listener" "listen80" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
  //Provides a Load Balancer Listener resource.
  load_balancer_arn = aws_lb.alb.arn
  //Create a listener on port 80 that forwards to the port 80 target group
  //Note that these ports don't have to be the same
  port     = "80"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG80.arn
  }

}

resource "aws_lb_listener" "listen9090" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
  //Provides a Load Balancer Listener resource.
  load_balancer_arn = aws_lb.alb.arn
  //Create a listener on port 9090 that forwards to the port 9090 target group
  //Note that these ports don't have to be the same
  port     = "9090"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG9090.arn
  }

}

