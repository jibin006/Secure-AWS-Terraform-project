

output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector"
  value       = aws_guardduty_detector.main.id
}

output "config_recorder_id" {
  description = "The ID of the AWS Config recorder"
  value       = aws_config_configuration_recorder.config.id
}

output "security_hub_enabled" {
  description = "Whether AWS Security Hub is enabled"
  value       = var.enable_security_hub
}