variable "aws_region" {
  description = "AWS region to deploy the resources"
	default = "us-east-1"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block to allow SSH access"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "github_repo" {
  description = "Github repo to clone"
	type        = string
}

variable "ssh_key_path" {
    default = "C:/Users/jemin/Downloads/devops.pem"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default = "192.168.1.0/24"
}

variable "private_key_path" {
  type = string
}

variable "instance_type" {
  description = "Type of EC2 instance to run"
  default     = "t3.large"
}