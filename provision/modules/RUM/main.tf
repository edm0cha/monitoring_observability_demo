resource "aws_cognito_identity_pool" "this" {
  identity_pool_name               = "${var.name}-rum-monitor"
  allow_unauthenticated_identities = true
  allow_classic_flow               = true
}

resource "aws_rum_app_monitor" "this" {
  name   = var.name
  domain = var.domain_name
  app_monitor_configuration {
    allow_cookies       = true
    identity_pool_id    = aws_cognito_identity_pool.this.id
    session_sample_rate = var.session_sample_rate
    telemetries = [
      "errors",
      "http",
      "performance",
    ]
  }
}
