//https://developer.hashicorp.com/terraform/language/values/outputs
//Output values make information about your infrastructure available on the command line, 
//and can expose information for other Terraform configurations to use. 
//Output values are similar to return values in programming languages.

output "vpc" {
  value = data.aws_vpc.main.tags
}

output "primary_subnet" {
  value = data.aws_subnet.public-1a.arn
}

output "public_subnets" {
  value = [for s in data.aws_subnet.public : s.id]
}

output "ami" {
  value = data.aws_ami.al2023.name
}

output "ecs_dns" {
  value = aws_instance.webserver.public_dns
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}