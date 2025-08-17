variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "billing_mode" {
  description = "Billing mode for the table (PAY_PER_REQUEST or PROVISIONED)."
  type        = string
}

variable "hash_key" {
  description = "Primary key (partition key) for the table."
  type        = string
}

variable "hash_key_type" {
  description = "Type of the primary key (S, N, or B)."
  type        = string
}

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery (true/false)."
  type        = bool
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
} 