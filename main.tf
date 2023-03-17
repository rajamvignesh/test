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

resource "aws_security_group" "demo-sg" {
  name = “sec-grp”
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "auto_deploy_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "terraform-dev-server"
  count = "1"
  ecs_associate_public_ip_address = "false"


  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }

  # vpc_security_group_ids = [
  #   var.security_grp
  # ]

  user_data = "${file(“userdata.sh”)}"

  depends_on = [ var.security_grp ]

  tags = {
    Name = "Test Web Server"
    BU = "Project Name"
    App-Name = "Project Name"
    Project = "Project Name"
  }
}