# standard syntax
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0"
    }
  }
}


provider "aws" {
  profile = "default"
  region  = "ap-south-1"           # mumbai region
}
