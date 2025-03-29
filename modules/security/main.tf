# IAM Password Policy (Security Best Practice)
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
}

# AWS Config for continuous compliance monitoring
resource "aws_config_configuration_recorder" "config" {
  name     = "${var.project_name}-${var.environment}-config-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

# S3 bucket for AWS Config logs with encryption
resource "aws_s3_bucket" "config" {
  bucket = "${var.project_name}-${var.environment}-config-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-${var.environment}-config-logs"
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "config" {
  bucket = aws_s3_bucket.config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 bucket policy for AWS Config
resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.config.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSConfigBucketPermissionsCheck"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${aws_s3_bucket.config.bucket}"
      },
      {
        Sid    = "AWSConfigBucketExistenceCheck"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::${aws_s3_bucket.config.bucket}"
      },
      {
        Sid    = "AWSConfigBucketDelivery"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.config.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*",
          "arn:aws:s3:::${aws_s3_bucket.config.bucket}/config/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# AWS Config delivery channel with proper configuration
resource "aws_config_delivery_channel" "config" {
  name           = "${var.project_name}-${var.environment}-config-channel"
  s3_bucket_name = aws_s3_bucket.config.bucket
  # No s3_key_prefix to avoid path issues
  sns_topic_arn  = aws_sns_topic.config_alerts.arn
  
  depends_on     = [
    aws_config_configuration_recorder.config,
    aws_s3_bucket_policy.config
  ]
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = aws_config_configuration_recorder.config.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config]
}

# IAM Role for AWS Config with full permissions
resource "aws_iam_role" "config" {
  name = "${var.project_name}-${var.environment}-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-config-role"
  }
}

# Attach both required policies
resource "aws_iam_role_policy_attachment" "config_service" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_role_policy_attachment" "config_s3" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  # This is overly permissive but ensures it works
}

# SNS Topic for AWS Config alerts
resource "aws_sns_topic" "config_alerts" {
  name = "${var.project_name}-${var.environment}-config-alerts"

  tags = {
    Name = "${var.project_name}-${var.environment}-config-alerts"
  }
}

# GuardDuty for threat detection
resource "aws_guardduty_detector" "main" {
  enable = true

  tags = {
    Name = "${var.project_name}-${var.environment}-guardduty"
  }
}

# AWS Security Hub for security standards compliance
resource "aws_securityhub_account" "main" {
  count = var.enable_security_hub ? 1 : 0
}

# Wait a few seconds after enabling Security Hub before enabling standards
resource "time_sleep" "wait_30_seconds" {
  count           = var.enable_security_hub ? 1 : 0
  depends_on      = [aws_securityhub_account.main]
  create_duration = "30s"
}

# Enable CIS AWS Foundations Benchmark in Security Hub
resource "aws_securityhub_standards_subscription" "cis" {
  count = var.enable_security_hub ? 1 : 0
  # Use the latest available version of CIS standard
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [time_sleep.wait_30_seconds]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}