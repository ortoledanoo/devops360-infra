# envs/dev/main.tf
# Development environment: Compose all infrastructure modules with dev-specific values.

module "vpc" {
  source               = "../../modules/vpc"
  region               = var.region
  cidr_block           = var.cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name
  environment          = var.environment
  cluster_name         = var.cluster_name
  tags                 = {}
}
# "kubernetes.io/cluster/${var.cluster_name}"

module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "${var.project_name}-${var.environment}-uploads"
  force_destroy     = true
  versioning_status = "Enabled"
  environment       = var.environment
}

module "dynamodb" {
  source                         = "../../modules/dynamodb"
  table_name                     = "${var.project_name}-${var.environment}-users"
  billing_mode                   = "PAY_PER_REQUEST"
  hash_key                       = "user_id"
  hash_key_type                  = "S"
  point_in_time_recovery_enabled = true
  environment                    = var.environment
}

module "cognito" {
  source                     = "../../modules/cognito"
  user_pool_name             = "${var.project_name}-${var.environment}-userpool"
  app_client_name            = "${var.project_name}-${var.environment}-appclient"
  password_min_length        = 8
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = false
  password_require_uppercase = true
  environment                = var.environment
}

module "ecr" {
  source   = "../../modules/ecr"
  ecr_name = "${var.project_name}-ecr"
}

# SSM Parameters for sharing outputs/configs
module "ssm_s3_bucket_name" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/s3_bucket_name"
  value  = module.s3.bucket_name
  type   = "String"
  tags   = { Name = "${var.project_name}-s3-bucket-name", Environment = "${var.environment}" }
}

module "ssm_cognito_user_pool_id" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/cognito_user_pool_id"
  value  = module.cognito.user_pool_id
  type   = "String"
  tags   = { Name = "${var.project_name}-cognito-user-pool-id", Environment = "${var.environment}" }
}

module "ssm_dynamodb_table_name" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/dynamodb_table_name"
  value  = module.dynamodb.table_name
  type   = "String"
  tags   = { Name = "${var.project_name}-dynamodb-table-name", Environment = "${var.environment}" }
}

module "ssm_vpc_id" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/vpc_id"
  value  = module.vpc.vpc_id
  type   = "String"
  tags   = { Name = "${var.project_name}-vpc-id", Environment = "${var.environment}" }
}

module "ssm_public_subnet_id" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/public_subnet_id"
  value  = module.vpc.public_subnet_ids[0]
  type   = "String"
  tags   = { Name = "${var.project_name}-public-subnet-id", Environment = "${var.environment}" }
}

module "ssm_private_subnet_id" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/private_subnet_id"
  value  = module.vpc.private_subnet_ids[0]
  type   = "String"
  tags   = { Name = "${var.project_name}-private-subnet-id", Environment = "${var.environment}" }
}

module "ssm_cognito_user_pool_client_id" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/cognito_user_pool_client_id"
  value  = module.cognito.user_pool_client_id
  type   = "String"
  tags   = { Name = "${var.project_name}-cognito-user-pool-client-id", Environment = "${var.environment}" }
}

module "ssm_cognito_client_secret_arn" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/cognito_client_secret_arn"
  value  = module.secretsmanager.secret_arn
  type   = "String"
  tags   = { Name = "${var.project_name}-cognito-client-secret-arn", Environment = "${var.environment}" }
}

module "ssm_ecr_repository_url" {
  source = "../../modules/ssm"
  name   = "/${var.project_name}/${var.environment}/ecr_repository_url"
  value  = module.ecr.repository_url
  type   = "String"
  tags   = { Name = "${var.project_name}-ecr-repository-url", Environment = "${var.environment}" }
}

# Secrets Manager for Cognito client secret
module "secretsmanager" {
  source = "../../modules/secretsmanager"
  name   = "${var.project_name}/cognito"
  secret_string = jsonencode({
    COGNITO_APP_CLIENT_SECRET = module.cognito.client_secret
    COGNITO_USER_POOL_ID      = module.cognito.user_pool_id
    COGNITO_APP_CLIENT_ID     = module.cognito.user_pool_client_id
  })
  recovery_window_in_days = 0
  description             = "Cognito app client secret for devops360"
  tags                    = { Name = "${var.project_name}-cognito-client-secret", Environment = "${var.environment}" }
}

module "eks" {
  source                   = "../../modules/eks"
  cluster_name             = var.cluster_name
  cluster_version          = var.cluster_version
  instance_types           = var.instance_types
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = module.vpc.private_subnet_ids
  min_size                 = var.min_size
  max_size                 = var.max_size
  desired_size             = var.desired_size
  ami_type                 = var.ami_type
  depends_on               = [module.vpc]
}

module "alb" {
  source = "../../modules/alb"

  cluster_name                       = module.eks.cluster_name
  vpc_id                             = module.vpc.vpc_id
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  oidc_provider_arn                  = module.eks.oidc_provider_arn
  depends_on                         = [module.eks]
}

module "k8s_app" {
  source = "../../modules/k8s-app"

  app_name                    = "${var.project_name}-app"
  service_type                = var.service_type
  image_name                  = var.image_name
  dynamodb_table_name         = module.dynamodb.table_name
  s3_bucket_name              = module.s3.bucket_name
  cognito_user_pool_id        = module.cognito.user_pool_id
  cognito_user_pool_client_id = module.cognito.user_pool_client_id
  cognito_secrets_arn         = module.secretsmanager.secret_arn
  oidc_provider_arn           = module.eks.oidc_provider_arn
  aws_region                  = var.region
  aws_account_id              = var.aws_account_id
  project_name                = var.project_name

  depends_on = [module.alb]
}