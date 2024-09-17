# VPC Creation
resource "aws_vpc" "lifinance_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = var.name
    }
}

# Create public subnets
resource "aws_subnet" "lifinance_pub_sub" {
    count = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
    vpc_id = aws_vpc.lifinance_vpc.id
    cidr_block = var.subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "publicSubnet${count.index + 1}"
    }
}

# Create IGW
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.lifinance_vpc.id
  tags = {
      Name = format("%s-%s-%s!", var.name, aws_vpc.lifinance.id, "IG")
  }
}