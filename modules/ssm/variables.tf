variable "name" {
  description = "Name of the SSM parameter."
  type        = string
}

variable "value" {
  description = "Value to store in the SSM parameter."
  type        = string
}

variable "type" {
  description = "Type of the SSM parameter (String, StringList, or SecureString)."
  type        = string
  default     = "String"
}

variable "tags" {
  description = "Tags to apply to the SSM parameter."
  type        = map(string)
  default     = {}
} 