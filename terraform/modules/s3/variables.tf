variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket (useful for dev/test)."
  type        = bool
}

variable "versioning_status" {
  description = "Versioning status for the bucket (Enabled or Suspended)."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
} 