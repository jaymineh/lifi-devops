variable "vpc_cidr" {
    default = "40.0.0.0/16"
}

variable "preferred_number_of_public_subnets" {
    default = null
}

variable "preferred_number_of_private_subnets" {
    default = null
}

variable "name" {
  default = "lifinance"
  type = string
}

variable "subnet_cidr" {
    default = "40.0.${count.index + 10}.0/24"
}