resource "aws_lb" "alb-tf" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
  //Provides a Load Balancer resource.
  name               = "WebServer-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb-tf.id]
  subnets            = [for subnet in data.aws_subnet.public : subnet.id]

}

resource "aws_lb_listener" "listen80" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
  //Provides a Load Balancer Listener resource.
  load_balancer_arn = aws_lb.alb-tf.arn
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
  load_balancer_arn = aws_lb.alb-tf.arn
  //Create a listener on port 9090 that forwards to the port 9090 target group
  //Note that these ports don't have to be the same
  port     = "9090"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port9090-tg-tf.arn
  }

}

