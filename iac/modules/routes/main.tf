# Create public route table
resource "aws_route_table" "publicrtb" {
    vpc_id = aws_vpc.lifinance_vpc.id
    tags = {
        Name = "Public Route Table"
    }
}

# Create route for the public route table
resource "aws_route" "publicroute" {
    route_table_id = aws_route_table.publicrtb.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
}

# Associate the public route table with the private subnet
resource "aws_route_table_association" "publicasso" {
  count = length(aws_subnet.public[*].id)
  subnet_id = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.publicrtb.id
}