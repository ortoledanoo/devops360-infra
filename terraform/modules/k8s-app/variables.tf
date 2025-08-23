variable "app_name" {
  description = "Name of My Application"
  type        = string
}

variable "service_type" {
  description = "Name of Service"
  type        = string
}

variable "image_name" {
  description = "Name of Image"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for the application"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for the application"
  type        = string
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN for IRSA"
  type        = string
}

variable "cognito_secrets_arn" {
  description = "ARN of the Cognito secrets in Secrets Manager"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}