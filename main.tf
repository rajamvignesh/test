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
  key_name = "auto-key-pair"
  count = "1"

  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }

  # vpc_security_group_ids = [
  #   var.security_grp
  # ]

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