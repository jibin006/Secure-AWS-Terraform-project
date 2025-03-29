module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  project_name       = var.project_name
  environment        = var.environment
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  enable_flow_logs   = var.enable_flow_logs
  enable_public_subnets = var.enable_public_subnets
  authorized_ips     = var.authorized_ips
}

module "security" {
  source = "./modules/security"

  project_name        = var.project_name
  environment         = var.environment
  enable_security_hub = var.enable_security_hub
}

# Optional: EC2 instance in private subnet for demo purposes
resource "aws_instance" "private_instance" {
  count         = var.deploy_demo_instance ? 1 : 0
  ami           = var.amazon_linux_ami
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnet_ids[0]
  vpc_security_group_ids = [module.vpc.private_security_group_id]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-private-instance"
  }
}

# Optional: Bastion host in public subnet for access
resource "aws_instance" "bastion" {
  count         = var.deploy_demo_instance && var.enable_public_subnets ? 1 : 0
  ami           = var.amazon_linux_ami
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.vpc.bastion_security_group_id]
  associate_public_ip_address = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion"
  }
}