variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "il-central-1"
}

variable "project_name" {
  description = "Project name prefix for all resources."
  type        = string
  default     = "devops360"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "cognito_secret_name" {
  description = "Name for the Cognito app client secret in Secrets Manager."
  type        = string
  default     = "devops360-dev-cognito-client-secret-test"
}

variable "cognito_secret_recovery_window_in_days" {
  description = "Number of days before a deleted secret is permanently removed. Use 0 for immediate deletion in dev environments."
  type        = number
  default     = 0
} 