# envs/dev/backend.tf
# Remote backend configuration for Terraform state (dev environment)
terraform {
  backend "s3" {
    bucket         = "ex4-or-toledano-bucket-tf" # S3 bucket for state
    key            = "terraform.tfstate"         # Path within the bucket
    region         = "il-central-1"              # AWS region
    dynamodb_table = "terraform_state_lock"      # DynamoDB table for state locking
    encrypt        = true                        # Encrypt state at rest
  }
} 