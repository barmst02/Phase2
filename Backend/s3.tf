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
}