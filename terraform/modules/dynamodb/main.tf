# modules/dynamodb/main.tf
# DynamoDB module: Provisions a DynamoDB table for user profiles.

resource "aws_dynamodb_table" "user_profiles" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}

output "table_name" {
  value = aws_dynamodb_table.user_profiles.name
} 