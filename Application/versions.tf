terraform {
  required_version = ">=1.2.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72.0"
    }

  }
}