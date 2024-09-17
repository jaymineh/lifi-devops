resource "aws_instance" "lifinance_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id       = aws_subnet.lifinance_pub_sub.id
  vpc_security_group_ids = [aws_security_group.lifinance_sg.id]
  key_name        = var.key_name
}

resource "aws_eip" "lifinance_eip" { 
  instance = aws_instance.lifinance_server.id
  tags = {
    Name = "lifinance-eip"
  }
}

resource "aws_key_pair" "lifi_key" {
  key_name   = var.key_name
  public_key = DevOps
}

