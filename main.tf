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

resource "aws_db_instance" "rds_instance" {

    engine = "mysql"
    engine_version = "8.0.27"
    identifier = "rds-terraform"
    instance_class = "db.t2.micro" 
    storage_type = "gp2"
    allocated_storage = 5
    max_allocated_storage = 10 
    name = "test"
    username = "admin"
    password = "admin"
    
}
