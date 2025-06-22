resource "aws_secretsmanager_secret" "cognito_client_secret" {
  name                    = var.cognito_secret_name
  recovery_window_in_days = var.cognito_secret_recovery_window_in_days
  description = "Cognito app client secret for ${var.project_name}"
  tags = {
    Name        = "${var.project_name}-cognito-client-secret"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "cognito_client_secret_value" {
  secret_id     = aws_secretsmanager_secret.cognito_client_secret.id
  secret_string = aws_cognito_user_pool_client.main.client_secret
} 