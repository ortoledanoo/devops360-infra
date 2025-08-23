variable "ecr_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for encrypting the repository. If not provided, AWS managed key will be used."
  type        = string
  default     = null
} 