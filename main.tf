# main.tf
# Entry point for the Terraform configuration. This file includes the ECR module, which provisions an Elastic Container Registry for storing Docker images.

module "ecr" {
  source = "./modules/ecr" # Path to the ECR module
  name   = "devops360-app" # Name for the ECR repository
} 