resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/${var.project_name}/${var.environment}/s3_bucket_name"
  type  = "String"
  value = aws_s3_bucket.uploads.bucket
  tags = {
    Name        = "${var.project_name}-s3-bucket-name"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "/${var.project_name}/${var.environment}/cognito_user_pool_id"
  type  = "String"
  value = aws_cognito_user_pool.main.id
  tags = {
    Name        = "${var.project_name}-cognito-user-pool-id"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "dynamodb_table_name" {
  name  = "/${var.project_name}/${var.environment}/dynamodb_table_name"
  type  = "String"
  value = aws_dynamodb_table.user_profiles.name
  tags = {
    Name        = "${var.project_name}-dynamodb-table-name"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-vpc-id"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "public_subnet_id" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_id"
  type  = "String"
  value = aws_subnet.public.id
  tags = {
    Name        = "${var.project_name}-public-subnet-id"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_id"
  type  = "String"
  value = aws_subnet.private.id
  tags = {
    Name        = "${var.project_name}-private-subnet-id"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "cognito_user_pool_client_id" {
  name  = "/${var.project_name}/${var.environment}/cognito_user_pool_client_id"
  type  = "String"
  value = aws_cognito_user_pool_client.main.id
  tags = {
    Name        = "${var.project_name}-cognito-user-pool-client-id"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "cognito_client_secret_arn" {
  name  = "/${var.project_name}/${var.environment}/cognito_client_secret_arn"
  type  = "String"
  value = aws_secretsmanager_secret.cognito_client_secret.arn
  tags = {
    Name        = "${var.project_name}-cognito-client-secret-arn"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "ecr_repository_url" {
  name  = "/${var.project_name}/${var.environment}/ecr_repository_url"
  type  = "String"
  value = module.ecr.repository_url
  tags = {
    Name        = "${var.project_name}-ecr-repository-url"
    Environment = var.environment
  }
} 