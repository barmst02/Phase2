//---------------------------------------------------------
// Target Groups
//---------------------------------------------------------

resource "aws_lb_target_group" "port80-tf-tf" {
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

resource "aws_lb_target_group_attachment" "lb_attach_80-tf" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
  //Provides the ability to register instances and containers with an Application Load Balancer (ALB) target group.
  target_group_arn = aws_lb_target_group.port80-tf-tf.arn
  //Register our EC2 instance as a target for the group
  target_id = aws_instance.webserver-tf.id
}

resource "aws_lb_target_group" "port9090-tg-tf" {
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

resource "aws_lb_target_group_attachment" "lb-attach-9090-tf" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
  //Provides the ability to register instances and containers with an Application Load Balancer (ALB) target group.
  target_group_arn = aws_lb_target_group.port9090-tg-tf.arn
  //Register our EC2 instance as a target for the group
  target_id = aws_instance.webserver-tf.id
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
    target_group_arn = aws_lb_target_group.port80-tf-tf.arn
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
    target_group_arn = aws_lb_target_group.port9090-tg-tf.arn
  }

}

