
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "secure-aws-infra"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs for network monitoring"
  type        = bool
  default     = true
}

variable "enable_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
  default     = true
}

variable "authorized_ips" {
  description = "List of authorized IP addresses that can access the bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # WARNING: This should be restricted in production
}

variable "enable_security_hub" {
  description = "Whether to enable AWS Security Hub"
  type        = bool
  default     = true
}

variable "deploy_demo_instance" {
  description = "Whether to deploy demo EC2 instances"
  type        = bool
  default     = false
}

variable "amazon_linux_ami" {
  description = "Amazon Linux 2 AMI ID"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # This should be updated with the latest AMI ID
}