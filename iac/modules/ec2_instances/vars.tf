variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be created"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to attach to the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The SSH key name to use for accessing the EC2 instance"
  type        = string
  default = "DevOps"
}

variable "instance_type" {
  description = "Type of EC2 instance to run"
  default     = "t3.large"
}

variable "ami_id" {
  description = "EC2 instance AMI"
  type = string
  default = "ami-0e86e20dae9224db8"
}

variable "github_repo" {
	type        = string
	default     = "https://github.com/jaymineh/lifi-devops.git"
}

variable "private_key_path" {
  type = string
}

variable "availability_zone" {
  description = "Availability Zone to launch the instance in"
  type        = string
  default     = "us-east-1a"
}
