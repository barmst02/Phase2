//https://developer.hashicorp.com/terraform/language/backend
//The backend defines where Terraform stores its state data files.
terraform {
  backend "s3" {
    //https://developer.hashicorp.com/terraform/language/backend/s3
    region = "us-gov-west-1"
    //The bucket must already exist
    bucket = "tf-brian-armstrong"

    key = "tf-backend/terraform.app.tfstate"
  }
}