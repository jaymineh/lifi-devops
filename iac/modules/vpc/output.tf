output "vpc_id" {
  value = aws_vpc.lifinance_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.lifinance_subnet.id
}