# envs/dev/providers.tf
# Provider configuration for development environment

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0, < 6.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

provider "aws" {
  region = "il-central-1"
  
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "devops360"
      ManagedBy   = "terraform"
    }
  }
}

provider "time" {
  # No specific configuration needed
} 