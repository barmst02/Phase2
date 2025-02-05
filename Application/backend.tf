terraform {
  backend "s3" {
    region = "us-gov-west-1"
    bucket = "tf-brian-armstrong"
    key    = "tf-backend/terraform.app.tfstate"
  }
}