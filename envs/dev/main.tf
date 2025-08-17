# envs/dev/main.tf
# Development environment: Compose all infrastructure modules with dev-specific values.

module "vpc" {
  source               = "../../modules/vpc"
  region               = "il-central-1"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  project_name         = "devops360"
  environment          = "dev"
  cluster_name         = "devops360-dev-eks"
  tags                 = {}
}

module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "devops360-dev-uploads"
  force_destroy     = true
  versioning_status = "Enabled"
  environment       = "dev"
}

module "dynamodb" {
  source                         = "../../modules/dynamodb"
  table_name                     = "devops360-dev-users"
  billing_mode                   = "PAY_PER_REQUEST"
  hash_key                       = "user_id"
  hash_key_type                  = "S"
  point_in_time_recovery_enabled = true
  environment                    = "dev"
}

module "cognito" {
  source                     = "../../modules/cognito"
  user_pool_name             = "devops360-dev-userpool"
  app_client_name            = "devops360-dev-appclient"
  password_min_length        = 8
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = false
  password_require_uppercase = true
  environment                = "dev"
}

module "ecr" {
  source = "../../modules/ecr"
  name   = "devops360-app"
}

# SSM Parameters for sharing outputs/configs
module "ssm_s3_bucket_name" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/s3_bucket_name"
  value  = module.s3.bucket_name
  type   = "String"
  tags   = { Name = "devops360-s3-bucket-name", Environment = "dev" }
}

module "ssm_cognito_user_pool_id" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/cognito_user_pool_id"
  value  = module.cognito.user_pool_id
  type   = "String"
  tags   = { Name = "devops360-cognito-user-pool-id", Environment = "dev" }
}

module "ssm_dynamodb_table_name" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/dynamodb_table_name"
  value  = module.dynamodb.table_name
  type   = "String"
  tags   = { Name = "devops360-dynamodb-table-name", Environment = "dev" }
}

module "ssm_vpc_id" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/vpc_id"
  value  = module.vpc.vpc_id
  type   = "String"
  tags   = { Name = "devops360-vpc-id", Environment = "dev" }
}

module "ssm_public_subnet_id" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/public_subnet_id"
  value  = module.vpc.public_subnet_ids[0]
  type   = "String"
  tags   = { Name = "devops360-public-subnet-id", Environment = "dev" }
}

module "ssm_private_subnet_id" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/private_subnet_id"
  value  = module.vpc.private_subnet_ids[0]
  type   = "String"
  tags   = { Name = "devops360-private-subnet-id", Environment = "dev" }
}

module "ssm_cognito_user_pool_client_id" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/cognito_user_pool_client_id"
  value  = module.cognito.user_pool_client_id
  type   = "String"
  tags   = { Name = "devops360-cognito-user-pool-client-id", Environment = "dev" }
}

module "ssm_cognito_client_secret_arn" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/cognito_client_secret_arn"
  value  = module.secretsmanager.secret_arn
  type   = "String"
  tags   = { Name = "devops360-cognito-client-secret-arn", Environment = "dev" }
}

module "ssm_ecr_repository_url" {
  source = "../../modules/ssm"
  name   = "/devops360/dev/ecr_repository_url"
  value  = module.ecr.repository_url
  type   = "String"
  tags   = { Name = "devops360-ecr-repository-url", Environment = "dev" }
}

# Secrets Manager for Cognito client secret
module "secretsmanager" {
  source                  = "../../modules/secretsmanager"
  name                    = "devops360-dev-cognito-client-secret-test"
  secret_string           = module.cognito.client_secret
  recovery_window_in_days = 0
  description             = "Cognito app client secret for devops360"
  tags                    = { Name = "devops360-cognito-client-secret", Environment = "dev" }
}

module "eks" {
  source                   = "../../modules/eks"
  cluster_name             = "devops360-dev-eks"
  cluster_version          = "1.32"
  instance_types           = ["t3.medium"]
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = module.vpc.private_subnet_ids
  min_size                 = 2
  max_size                 = 4
  desired_size             = 2
  depends_on = [module.vpc]
}

module "alb" {
  source = "../../modules/alb"

  cluster_name                       = module.eks.cluster_name
  vpc_id                             = module.vpc.vpc_id
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  oidc_provider_arn                  = module.eks.oidc_provider_arn
  depends_on = [module.eks]
}

module "k8s_app" {
  source = "../../modules/k8s-app"

  app_name                     = "devops360-app"
  service_type                 = "NodePort"
  image_name                   = "ortoledanoo/devops360-app:latest"
  dynamodb_table_name          = module.dynamodb.table_name
  s3_bucket_name               = module.s3.bucket_name
  cognito_user_pool_id         = module.cognito.user_pool_id
  cognito_user_pool_client_id  = module.cognito.user_pool_client_id
  oidc_provider_arn            = module.eks.oidc_provider_arn

  depends_on = [module.alb]
}