resource "aws_vpc" "lifinance_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "lifinance_vpc"
  }
}

resource "aws_subnet" "lifinance_subnet" {
  vpc_id     = aws_vpc.lifinance_vpc.id
  cidr_block = var.vpc_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = "lifinance_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lifinance_vpc.id

  tags = {
    Name = "lifinance_gw"
  }
}

resource "aws_route_table" "lifinance" {
  vpc_id = aws_vpc.lifinance_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.lifinance_subnet.id
  route_table_id = aws_route_table.lifinance.id
}
