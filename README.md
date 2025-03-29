# Secure AWS Infrastructure with Terraform

This project demonstrates how to create a secure AWS infrastructure using Terraform, implementing cloud security best practices.

## Architecture Overview

This project creates:

1. **Secure Network Infrastructure**
   - VPC with public and private subnets
   - Network segmentation with proper routing
   - VPC Flow Logs for network monitoring

2. **Security Controls**
   - AWS GuardDuty for threat detection
   - AWS Config for compliance monitoring
   - AWS Security Hub for security standards (optional)
   - IAM password policy for account security
   - Restricted security groups

3. **Secure Access**
   - Bastion host for secure SSH access to private instances (optional)
   - Private instances with no direct internet access

## Prerequisites

- AWS account with administrator access
- Terraform installed (v1.0.0 or newer)
- AWS CLI configured with your credentials

## Getting Started

1. Clone this repository
2. Navigate to the project directory:
   ```bash
   cd aws-secure-terraform-project
   ```
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Review the planned changes:
   ```bash
   terraform plan
   ```
5. Apply the changes:
   ```bash
   terraform apply
   ```

## Security Features

### Network Security
- **Network Segmentation**: Public and private subnets with appropriate routing
- **VPC Flow Logs**: Network traffic monitoring for security analysis
- **Secure Security Groups**: Restricted network access

### Identity and Access Management
- **Strong Password Policy**: Enforces complex passwords
- **Least Privilege Access**: IAM roles with minimal permissions

### Monitoring and Detection
- **AWS GuardDuty**: Continuous threat detection
- **AWS Config**: Configuration compliance monitoring
- **AWS Security Hub**: Centralized security standards (optional)

### Data Protection
- **S3 Bucket Encryption**: Server-side encryption for all data
- **No Public Access**: S3 buckets blocked from public access

## Customization

Edit the `variables.tf` file to customize:
- AWS region
- CIDR ranges
- Security controls
- Whether to deploy demo instances

## Security Best Practices Implemented

1. **Defense in Depth**: Multiple security layers
2. **Least Privilege**: Minimal permissions
3. **Network Segmentation**: Isolated network zones
4. **Encryption**: Data protection in transit and at rest
5. **Monitoring**: Continuous security monitoring
6. **Compliance**: Framework alignment via AWS Config

## Clean Up

To destroy all resources created by this project:
```bash
terraform destroy
```

## Important Notes

- The default `authorized_ips` value is set to `0.0.0.0/0` for demonstration purposes. In a production environment, this should be restricted to your specific IP addresses.
- The bastion host and EC2 instances are optional and disabled by default. Enable them by setting `deploy_demo_instance = true`.
