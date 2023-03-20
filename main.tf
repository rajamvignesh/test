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

resource "aws_security_group" "auto-created-sg" {
  name = "auto-created-sg"
  description = "Allow SSH traffic via Terraform"

  #Incoming traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Incoming traffic
  ingress {
    from_port   = 402
    to_port     = 402
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outgoing traffic
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
  count = 1
  #ecs_associate_public_ip_address = "false"
  tenancy = "default"

  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
    encrypted   = true
  }

  security_groups = ["auto-created-sg"]
  user_data = "${file("userdata.sh")}"

  depends_on = [ "auto-created-sg" ]

  tags = {
      Name = var.server_name
      BU = "Project Name"
      App-Name = "Project Name"
      Project = "Project Name"
  }
}

output "ip" {
  value = "${aws_instance.auto_deploy_server.*.public_ip}"
}
