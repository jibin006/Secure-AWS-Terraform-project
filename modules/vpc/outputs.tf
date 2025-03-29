output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "bastion_security_group_id" {
  description = "ID of the bastion host security group"
  value       = var.enable_public_subnets ? aws_security_group.bastion[0].id : null
}

output "private_security_group_id" {
  description = "ID of the private instances security group"
  value       = aws_security_group.private_instances.id
}