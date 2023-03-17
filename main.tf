variable "instance_type" {
 type = string
 default = "t2.micro"
 description = "EC2 instance type"
}

variable "ami_id" {
 type = string
 description = "AMI instance id"
}

variable "region" {
 type = string
 description = "aws region"
}

variable "security_grp" {
 type = string
 description = "aws region"
}


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
  region  = var.region
}

resource "aws_instance" "auto_deploy_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "auto-server-tf"
  count = "1"

  root_block_device {
    delete_on_termination = true
    iops = 100
    volume_size = 50
    volume_type = "gp2"
  }

  vpc_security_group_ids = [
    "sg-04a7bbd1910030844"
  ]

  user_data = <<EOF
      #!/bin/bash
      echo "Copying the SSH Key Of Jenkins to the server"
      echo "Changing Hostname"
      EOF

  depends_on = [ var.security_grp ]

  tags = {
    Name = "server for web"
    Env = "dev"
  }
}