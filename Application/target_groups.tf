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

