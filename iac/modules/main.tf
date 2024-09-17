provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr
}

module "routes" {
    source = "./modules/routes"
    vpc_id = module.vpc.vpc_id
    public_subnet_id = module.vpc.aws_subnet.lifinance_pub_sub.id
    internet_gateway_id = module.vpc.aws_internet_gateway.ig.id
}

module "nsg" {
  source = "./modules/nsg"
  vpc_id = module.vpc.vpc_id_lifi.id
  allowed_ssh_cidr = xlarge
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = element(aws_subnet.public[*].id, count.index)
  security_group_id = module.nsg.nsg_id
  key_name          = module.ec2.lifi_key.key_name
  instance_type     = module.ec2.var.instance_type
  ami_id            = module.ec2.var.ami_id
}

output "ec2_instance_public_ip" {
  value = module.ec2_instances.public_instance_ip
}