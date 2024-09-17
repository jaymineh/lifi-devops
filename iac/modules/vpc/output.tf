output "PublicIP" {
  value = ["${aws_subnet.public.*.id}"]
}

output "vpc_id_lifi" {
  value = aws_vpc.lifinance_vpc.id
}

output "public_subnet_id_lifi" {
  value = aws_subnet.lifinance_pub_sub.id
}

