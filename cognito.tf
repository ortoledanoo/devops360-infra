# cognito.tf
# Provisions AWS Cognito resources for user authentication and authorization.
# Includes a user pool (user directory) and an app client for application integration.

# Cognito User Pool: Manages user registration, authentication, and profile management
resource "aws_cognito_user_pool" "main" {
  # Name of the user pool, dynamically set for project and environment
  name = "${var.project_name}-${var.environment}-userpool"

  # Allow users to sign in with their email address
  alias_attributes = ["email"]

  # Automatically verify users' email addresses
  auto_verified_attributes = ["email"]

  # Password policy for user accounts
  password_policy {
    minimum_length    = 8      # Minimum password length
    require_lowercase = true   # Require at least one lowercase letter
    require_numbers   = true   # Require at least one number
    require_symbols   = false  # Symbols not required
    require_uppercase = true   # Require at least one uppercase letter
  }

  # Tags for resource identification and cost allocation
  tags = {
    Name        = "${var.project_name}-userpool"
    Environment = var.environment
  }
}

# Cognito User Pool Client: Application integration for authentication
resource "aws_cognito_user_pool_client" "main" {
  # Name of the app client
  name         = "${var.project_name}-${var.environment}-appclient"
  # Reference to the user pool
  user_pool_id = aws_cognito_user_pool.main.id
  # Generate a client secret for secure authentication
  generate_secret = true
  # Allowed authentication flows for the app client
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",   # Allow username/password authentication
    "ALLOW_REFRESH_TOKEN_AUTH",   # Allow refresh token authentication
    "ALLOW_USER_SRP_AUTH"         # Allow Secure Remote Password protocol
  ]
  # Prevent user existence errors from leaking information
  prevent_user_existence_errors = "ENABLED"
} 