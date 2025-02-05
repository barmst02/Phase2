data "aws_vpc" "main" {
  filter {
    name = "tag:Name"
    values = ["*tf"]
  }
}

variable "on_prem_ip" {
  description = "the on-prem IP list"
  default     = ["10.0.0.0/8", "162.77.0.0/16", "172.16.0.0/12", "3.83.200.219/32"]
}

variable "my_ip" {
  description = "the IP address of FRS Workspaces"
  default = "3.83.200.219/32"
}