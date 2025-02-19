resource "aws_s3_bucket" "s3_backend" {
  bucket = "<firstname.lastname>-tf"
}

provider "aws" {
  region  = "us-gov-west-1"
 }