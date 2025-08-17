variable "user_pool_name" {
  description = "Name of the Cognito user pool."
  type        = string
}

variable "app_client_name" {
  description = "Name of the Cognito app client."
  type        = string
}

variable "password_min_length" {
  description = "Minimum password length."
  type        = number
}

variable "password_require_lowercase" {
  description = "Require at least one lowercase letter in password."
  type        = bool
}

variable "password_require_numbers" {
  description = "Require at least one number in password."
  type        = bool
}

variable "password_require_symbols" {
  description = "Require at least one symbol in password."
  type        = bool
}

variable "password_require_uppercase" {
  description = "Require at least one uppercase letter in password."
  type        = bool
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
} 