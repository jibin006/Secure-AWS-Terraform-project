output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "bastion_security_group_id" {
  description = "ID of the bastion host security group"
  value       = module.vpc.bastion_security_group_id
}

output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector"
  value       = module.security.guardduty_detector_id
}

output "config_recorder_id" {
  description = "The ID of the AWS Config recorder"
  value       = module.security.config_recorder_id
}

output "security_hub_enabled" {
  description = "Whether AWS Security Hub is enabled"
  value       = module.security.security_hub_enabled
}

output "bastion_public_ip" {
  description = "The public IP of the bastion host"
  value       = var.deploy_demo_instance && var.enable_public_subnets ? aws_instance.bastion[0].public_ip : null
}

output "private_instance_private_ip" {
  description = "The private IP of the demo instance"
  value       = var.deploy_demo_instance ? aws_instance.private_instance[0].private_ip : null
}