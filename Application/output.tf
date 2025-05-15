//https://developer.hashicorp.com/terraform/language/values/outputs
//Output values make information about your infrastructure available on the command line, 
//and can expose information for other Terraform configurations to use. 
//Output values are similar to return values in programming languages.

output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "public_1a_subnet_id" {
  value = data.aws_subnet.public-1a.id
}

output "public_2a_subnet_id" {
  value = data.aws_subnet.public-1a.id
}

#output "primary_subnet_detail" {
#  value = data.aws_subnet.public-1a
#}

#output "public_subnets" {
#  value = [for s in data.aws_subnet.public : s.id]
#}

output "ami" {
  value = data.aws_ami.al2023.name
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}
output "ecs_dns" {
  value = aws_instance.webserver.public_dns
}

output "ecs_ip" {
  value = aws_instance.webserver.public_ip
}

