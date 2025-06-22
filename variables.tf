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