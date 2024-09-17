variable "instance_type" {
  description = "EC2 instance type"
  default = "t3.xlarge"
}

variable "ami_id" {
  description = "EC2 AMI ID"
  default = "ami-0e86e20dae9224db8"
}

variable "key_name" {
  description = "The SSH key name to use for accessing the EC2 instance"
  type = string
  default = "DevOps"
}