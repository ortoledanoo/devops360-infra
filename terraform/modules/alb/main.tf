resource "aws_iam_policy" "load_balancer_controller_additional" {
  name        = "${var.cluster_name}-load-balancer-controller-additional"
  description = "Additional permissions for AWS Load Balancer Controller"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ]
        Resource = [
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/*",
          "arn:aws:elasticloadbalancing:*:*:targetgroup/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:DeleteTargetGroup"
        ]
        Resource = "arn:aws:elasticloadbalancing:*:*:targetgroup/*"
      }
    ]
  })
}

module "aws_load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.1"

  role_name = "${var.cluster_name}-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  role_policy_arns = {
    additional = aws_iam_policy.load_balancer_controller_additional.arn
  }

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.4"

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.aws_load_balancer_controller_irsa_role.iam_role_arn
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "enableShield"
    value = "false"
  }

  set {
    name  = "enableWafv2"
    value = "false"
  }

  depends_on = [module.aws_load_balancer_controller_irsa_role]
}