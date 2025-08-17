# modules/cognito/main.tf
# Cognito module: Provisions a Cognito user pool and app client for authentication.

resource "aws_cognito_user_pool" "main" {
  name                     = var.user_pool_name
  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length    = var.password_min_length
    require_lowercase = var.password_require_lowercase
    require_numbers   = var.password_require_numbers
    require_symbols   = var.password_require_symbols
    require_uppercase = var.password_require_uppercase
  }
  tags = {
    Name        = var.user_pool_name
    Environment = var.environment
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name            = var.app_client_name
  user_pool_id    = aws_cognito_user_pool.main.id
  generate_secret = true
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
  prevent_user_existence_errors = "ENABLED"
}

output "user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.main.id
}

output "client_secret" {
  value = aws_cognito_user_pool_client.main.client_secret
} 