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
