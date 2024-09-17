resource "aws_security_group" "lifinance_sg" {
  name = var.name
  description = var.name
  vpc_id = aws_vpc.lifinance.id

  dynamic "ingress" {
    iterator = port
    for_each = var.public_ports
    content {
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = [var.anywhere]
    }
  }

  dynamic "ingress" {
    iterator = port
    for_each = var.restricted_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = [var.bastion_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Outbound"
  }

  tags = {
    Name = var.name
  }
}