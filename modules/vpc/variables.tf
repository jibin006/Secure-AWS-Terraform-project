variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
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