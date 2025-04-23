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

resource "aws_security_group" "sg-alb-tf" {
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

resource "aws_security_group" "sg-ec2-tf" {
  description = "Inbound access for EC2"
  name        = "ec2_sg"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    //Allow port 80 from the Load Balancer (specifically from the Load Balancer security group)
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-alb-tf.id]
  }
  ingress {
    //Allow port 9090 from the Load Balancer (specifically from the Load Balancer security group)
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-alb-tf.id]
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
