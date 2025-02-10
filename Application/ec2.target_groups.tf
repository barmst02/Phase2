resource "aws_lb_target_group" "TG80" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  target_type = "instance"

  health_check {
    enabled           = true
    healthy_threshold = 2
    interval          = 10
    timeout           = 6

  }
}

resource "aws_lb_target_group_attachment" "LB_attach_80" {
  target_group_arn = aws_lb_target_group.TG80.arn
  target_id        = aws_instance.webserver.id
}

resource "aws_lb_target_group" "TG9090" {
  port     = 9090
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  target_type = "instance"

  health_check {
    enabled           = true
    healthy_threshold = 2
    interval          = 10
    timeout           = 6

  }

}

resource "aws_lb_target_group_attachment" "LB_attach_9090" {
  target_group_arn = aws_lb_target_group.TG9090.arn
  target_id        = aws_instance.webserver.id
}
