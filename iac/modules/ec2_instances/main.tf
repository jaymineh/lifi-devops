resource "aws_instance" "lifinance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = [var.security_group_id]
	key_name = var.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt upgrade -y
    sudo apt install software-properties-common -y
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install git ansible -y
  EOF

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  } 
	tags = {
		Name = "lifinance"
	}
}

resource "aws_eip" "lifinance_eip" {
  instance = aws_instance.lifinance.id
  tags = {
    Name = "lifinance_eip"
  }
}

output "elastic_ip" {
  value = aws_eip.lifinance_eip.public_ip
}
