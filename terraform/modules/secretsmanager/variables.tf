variable "name" {
  description = "Name of the secret."
  type        = string
}

variable "secret_string" {
  description = "The secret value to store."
  type        = string
}

variable "recovery_window_in_days" {
  description = "Number of days before a deleted secret is permanently removed. Use 0 for immediate deletion in dev environments."
  type        = number
  default     = 7
}

variable "description" {
  description = "Description of the secret."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the secret."
  type        = map(string)
  default     = {}
}

variable "kms_key_id" {
  description = "KMS key ID for encrypting the secret. If not provided, AWS managed key will be used."
  type        = string
  default     = null
} 