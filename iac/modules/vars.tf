variable "instance_type" {
  description = "Type of EC2 instance to run"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
}

variable "aws_region" {
  description = "AWS region for resource deployment"
  default = "us-east-1"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block to allow SSH access"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "github_repo" {
  description = "Github repo to clone"
  type        = string
}

variable "ssh_key_path" {
  description = "The path to the SSH public key file"
}


