resource "aws_s3_bucket" "s3_backend" {
  bucket = "tf-brian-armstrong"

  tags = {
    Name = "Backend"
  }
}

provider "aws" {
  //https://registry.terraform.io/browse/providers
  //Providers are a logical abstraction of an upstream API. They are responsible for understanding API interactions and exposing resources. 
  region  = "us-gov-west-1"
  profile = "default"
}

//This file is static and will be used as-is across all projects. 

terraform {
  //While these versions aren't restricted in the Launchpad, they are for CFS2
  //This is documented on "Supported Terraform Versions" in the Cloud Library 
  required_version = "<=1.9.8"  //of Terraform

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.19.0"
    }
  }
}