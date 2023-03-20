variable "region" {
 type = string
 description = "aws region"
}

variable "instance_type" {
 type = string
 default = "t2.micro"
 description = "EC2 instance type"
}

variable "ami_id" {
 type = string
 description = "AMI instance id"
}

variable "server_name" {
 type = string
 default = "Test Web Server"
 description = "aws region"
}