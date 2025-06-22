# envs/prod/main.tf
# Production environment: Compose all infrastructure modules with prod-specific values.

module "vpc" {
  source              = "../../modules/vpc"
  cidr_block          = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
  availability_zone   = "il-central-1a"
  project_name        = "devops360"
  environment         = "prod"
}

module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "devops360-prod-uploads"
  force_destroy     = false
  versioning_status = "Enabled"
  environment       = "prod"
}

module "dynamodb" {
  source                        = "../../modules/dynamodb"
  table_name                    = "devops360-prod-users"
  billing_mode                  = "PAY_PER_REQUEST"
  hash_key                      = "user_id"
  hash_key_type                 = "S"
  point_in_time_recovery_enabled = true
  environment                   = "prod"
}

module "cognito" {
  source                    = "../../modules/cognito"
  user_pool_name            = "devops360-prod-userpool"
  app_client_name           = "devops360-prod-appclient"
  password_min_length       = 12
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = true
  password_require_uppercase = true
  environment               = "prod"
}

module "ecr" {
  source = "../../modules/ecr"
  name   = "devops360-app"
}

# SSM Parameters for sharing outputs/configs
module "ssm_s3_bucket_name" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/s3_bucket_name"
  value  = module.s3.bucket_name
  type   = "String"
  tags   = { Name = "devops360-s3-bucket-name", Environment = "prod" }
}

module "ssm_cognito_user_pool_id" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/cognito_user_pool_id"
  value  = module.cognito.user_pool_id
  type   = "String"
  tags   = { Name = "devops360-cognito-user-pool-id", Environment = "prod" }
}

module "ssm_dynamodb_table_name" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/dynamodb_table_name"
  value  = module.dynamodb.table_name
  type   = "String"
  tags   = { Name = "devops360-dynamodb-table-name", Environment = "prod" }
}

module "ssm_vpc_id" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/vpc_id"
  value  = module.vpc.vpc_id
  type   = "String"
  tags   = { Name = "devops360-vpc-id", Environment = "prod" }
}

module "ssm_public_subnet_id" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/public_subnet_id"
  value  = module.vpc.public_subnet_id
  type   = "String"
  tags   = { Name = "devops360-public-subnet-id", Environment = "prod" }
}

module "ssm_private_subnet_id" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/private_subnet_id"
  value  = module.vpc.private_subnet_id
  type   = "String"
  tags   = { Name = "devops360-private-subnet-id", Environment = "prod" }
}

module "ssm_cognito_user_pool_client_id" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/cognito_user_pool_client_id"
  value  = module.cognito.user_pool_client_id
  type   = "String"
  tags   = { Name = "devops360-cognito-user-pool-client-id", Environment = "prod" }
}

module "ssm_cognito_client_secret_arn" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/cognito_client_secret_arn"
  value  = module.secretsmanager.secret_arn
  type   = "String"
  tags   = { Name = "devops360-cognito-client-secret-arn", Environment = "prod" }
}

module "ssm_ecr_repository_url" {
  source = "../../modules/ssm"
  name   = "/devops360/prod/ecr_repository_url"
  value  = module.ecr.repository_url
  type   = "String"
  tags   = { Name = "devops360-ecr-repository-url", Environment = "prod" }
}

# Secrets Manager for Cognito client secret
module "secretsmanager" {
  source                  = "../../modules/secretsmanager"
  name                    = "devops360-prod-cognito-client-secret"
  secret_string           = module.cognito.client_secret
  recovery_window_in_days = 7
  description             = "Cognito app client secret for devops360"
  tags                    = { Name = "devops360-cognito-client-secret", Environment = "prod" }
} 