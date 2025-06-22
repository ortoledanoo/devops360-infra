output "s3_bucket_name" {
  value = aws_s3_bucket.uploads.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.user_profiles.name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.main.id
}

output "cognito_client_secret_arn" {
  value = aws_secretsmanager_secret.cognito_client_secret.arn
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
} 