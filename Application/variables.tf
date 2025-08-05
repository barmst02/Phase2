//https://developer.hashicorp.com/terraform/language/values/variables
//Input variables let you customize aspects of Terraform modules without altering the module's own source code. 
//This functionality allows you to share modules across different Terraform configurations, making your module composable and reusable.

variable "my_ip" {
  description = "the IP address of all FRS Workspaces"
  default     = "3.83.200.219/32"
}

variable "ec2_ami" {
  description = "the AMI to use when launching an EC2"
  default     = "ami-06cf22f69c918a2c1"
}