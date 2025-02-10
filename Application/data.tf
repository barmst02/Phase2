//Find the correct VPC
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["*tf"]
  }
}

//Identify the AL2023 AMI to use
data "aws_ami" "al2023" {
  most_recent = true
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
  vpc_id = data.aws_vpc.main.id


  filter {
    name   = "tag:Name"
    values = ["Public 1a"]
  }
}

data "aws_subnets" "public" {
  //
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["Public*"]
  }
  //tags = {
  // name = "Public*"
  //}
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}