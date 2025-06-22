# dynamodb.tf
# Provisions a DynamoDB table for storing user profile data.
# This table is designed for scalability, reliability, and cost-efficiency.

resource "aws_dynamodb_table" "user_profiles" {
  # The name of the DynamoDB table, dynamically set based on project and environment
  name         = "${var.project_name}-${var.environment}-users"

  # Billing mode set to PAY_PER_REQUEST (on-demand), so you only pay for what you use
  # Alternative: PROVISIONED (requires setting read/write capacity units)
  billing_mode = "PAY_PER_REQUEST"

  # The primary key for the table (partition key)
  hash_key     = "user_id"

  # Attribute definition for the primary key
  attribute {
    name = "user_id" # The name of the partition key attribute
    type = "S"       # Attribute type: S = String, N = Number, B = Binary
  }

  # Enable point-in-time recovery for backup and restore (highly recommended for production)
  point_in_time_recovery {
    enabled = true
  }

  # Tags for resource identification and cost allocation
  tags = {
    Name        = "${var.project_name}-users"
    Environment = var.environment
  }
} 