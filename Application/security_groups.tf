//---------------------------------------------------------
// Default SG
//---------------------------------------------------------

resource "aws_default_security_group" "default" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
  //Provides a resource to manage a default security group. 
  vpc_id = data.aws_vpc.main.id
  //As a best practice, we delete all inbound rules from the default security group
}

resource "aws_vpc_security_group_egress_rule" "default-egress" {
  security_group_id = aws_default_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

//---------------------------------------------------------
// ALB SG
//---------------------------------------------------------

resource "aws_security_group" "sg-alb" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  //Provides a security group resource.
  description = "Inbound access for ALB"
  name        = "alb_sg-tf"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "alb-80-myip" {
  security_group_id = aws_security_group.sg-alb.id
  //Allow port 80 from the AWS Workspace
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.my_ip
}

resource "aws_vpc_security_group_ingress_rule" "alb-9090-myip" {
  security_group_id = aws_security_group.sg-alb.id
  //Allow port 9090 from the AWS Workspace
  from_port   = 9090
  to_port     = 9090
  ip_protocol = "tcp"
  cidr_ipv4   = var.my_ip
}

resource "aws_vpc_security_group_egress_rule" "alb-egress" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

//---------------------------------------------------------
// EC2 SG
//---------------------------------------------------------

resource "aws_security_group" "sg-ec2" {
    //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  //Provides a security group resource.
  description = "Inbound access for EC2"
  name        = "ec2_sg-tf"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "ec2-80-myip" {
  security_group_id = aws_security_group.sg-ec2.id
  //Allow port 80 from the AWS Workspace
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.my_ip
}

resource "aws_vpc_security_group_ingress_rule" "ec2-9090-myip" {
  security_group_id = aws_security_group.sg-ec2.id
  //Allow port 9090 from the AWS Workspace
  from_port   = 9090
  to_port     = 9090
  ip_protocol = "tcp"
  cidr_ipv4   = var.my_ip
}

resource "aws_vpc_security_group_ingress_rule" "ec2-80-alb" {
  security_group_id = aws_security_group.sg-ec2.id
  //Allow port 80 from the AWS Workspace
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.sg-alb.id
}

resource "aws_vpc_security_group_ingress_rule" "ec2-9090-alb" {
  security_group_id = aws_security_group.sg-ec2.id
  //Allow port 9090 from the AWS Workspace
  from_port   = 9090
  to_port     = 9090
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.sg-alb.id
}

resource "aws_vpc_security_group_egress_rule" "ec2-egress" {
  security_group_id = aws_security_group.sg-ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
