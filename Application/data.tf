//https://developer.hashicorp.com/terraform/language/data-sources
//Data sources allow Terraform to use information defined outside of Terraform, 
//defined by another separate Terraform configuration, or modified by functions.

//In our case, we use data sources to read information from our AWS environment

data "aws_vpc" "main" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
  //Provides details about a specific VPC.
  filter {
    //Find the VPC we want by looking for one that ends in "tf". 
    name   = "tag:Name"
    values = ["*tf"]
  }
}


data "aws_ami" "al2023" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
  //Use this data source to get the ID of a registered AMI for use in other resources.
  owners = [ "580842271618" ]
  most_recent = true
  //Identify the AL2023 AMI to use for our EC2 instance
  filter {
    name   = "name"
    values = ["al2023-ami-minimal*"]
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

data "aws_subnet" "public-1a" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet
  //Provides details about a specific VPC subnet.
  vpc_id = data.aws_vpc.main.id
  //Find the Subnet we want by searching for the name "Public 1a". 
  filter {
    name   = "tag:Name"
    values = ["Public 1a"]
  }
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
    name   = "tag:Name"
    values = ["Public*"]
  }
}

data "aws_subnet" "public" {
  //https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  //Instead of providing details about a specific VPC subnet, we are creating a set containing multiple subnets
  //This is used when creating the load balancer.
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}