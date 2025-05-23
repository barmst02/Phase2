//This file is static and will be used as-is across all projects. 

# terraform {
#   //While these versions aren't restricted in the Launchpad, they are for CFS2
#   //This is documented on "Supported Terraform Versions" in the Cloud Library 
#   required_version = "<=1.9.8" //of Terraform

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }

  #required_version = "~> 1.1.9"
}