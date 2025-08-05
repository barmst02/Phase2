//https://developer.hashicorp.com/terraform/language/data-sources
//Data sources allow Terraform to use information defined outside of Terraform, 
//defined by another separate Terraform configuration, or modified by functions.

//In our case, we use data sources to read information from our AWS environment

data "aws_vpc" "main" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
  //Provides details about a specific VPC.
  default = true
}

data "aws_subnet" "public-1a" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet
  //Provides details about a specific VPC subnet.
  vpc_id = data.aws_vpc.main.id
  //Find the Subnet we want by searching for the availability zone
  availability_zone = "us-gov-west-1a"
}

data "aws_subnet" "public-1b" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet
  //Provides details about a specific VPC subnet.
  vpc_id = data.aws_vpc.main.id
  //Find the Subnet we want by searching for the availability zone
  availability_zone = "us-gov-west-1b"
}











data "aws_subnets" "public" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets
  //Retrieves a set of all subnets in a VPC
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    //Find the Subnets with a name starting with "Public". 
    name   = "map-public-ip-on-launch"
    values = [true]
  }
}

data "aws_subnet" "public" {
  //https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  //Instead of providing details about a specific VPC subnet, we are creating a set containing multiple subnets
  //This is used when creating the load balancer.
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_ami" "al2023" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
  //Use this data source to get the ID of a registered AMI for use in other resources.
  owners      = ["045324592363"]
  most_recent = true
  //Identify the AL2023 AMI to use for our EC2 instance
  filter {
    name   = "name"
    values = ["al2023-ami-20*x86_64"]
    //amazon/al2023-ami-2023.6.20250218.2-kernel-6.1-x86_64
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

