provider "aws" {
  //https://registry.terraform.io/browse/providers
  //Providers are a logical abstraction of an upstream API. They are responsible for understanding API interactions and exposing resources. 
  region  = "us-gov-west-1"
  profile = "default"
}