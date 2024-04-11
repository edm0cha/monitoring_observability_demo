output "application_monitor_id" {
  value = aws_rum_app_monitor.this.app_monitor_id
}

output "cognito_identity_pool_id" {
  value = aws_cognito_identity_pool.this.id
}

output "guest_role_arn" {
  value = aws_iam_role.authenticated.arn
}
