variable "public_ports" {
  type = list(number)
  default = [30001,30002,30003,30004]
}

variable "restricted_ports" {
  type = list(number)
  default = [22]
}

variable "bastion_cidr" {
    type = string
    description = "CIDR for bastion host"
    default = "40.0.0.0/16"
}

variable "anywhere" {
    default = "0.0.0.0/0"
}

variable "name" {
  default = "lifinance_sg"
  type = string
}