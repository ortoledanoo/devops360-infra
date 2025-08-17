# IAM Policy for application permissions
resource "aws_iam_policy" "app_policy" {
  name        = "${var.app_name}-policy"
  description = "Policy for ${var.app_name} application"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:SignUp",
          "cognito-idp:InitiateAuth",
          "cognito-idp:ConfirmSignUp"
        ]
        Resource = "*"
      }
    ]
  })
}

# IRSA Role for Service Account
module "app_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.app_name}-irsa-role"

  role_policy_arns = {
    policy = aws_iam_policy.app_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["default:${var.app_name}-service-account"]
    }
  }
}

# Kubernetes Service Account
resource "kubernetes_service_account" "app_service_account" {
  metadata {
    name      = "${var.app_name}-service-account"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.app_irsa_role.iam_role_arn
    }
  }
}
