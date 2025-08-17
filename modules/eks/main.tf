module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Removed 'bootstrap_self_managed_addons = false' to allow the module to manage EKS core addons
  # defined in 'cluster_addons'. This resolves conflicts for managed node groups.

  cluster_addons = {
    vpc-cni                = { most_recent = true }
    coredns                = {}
    kube-proxy             = {}
    eks-pod-identity-agent = {}
  }

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  eks_managed_node_groups = {
    example = {
      ami_type       = var.ami_type
      instance_types = var.instance_types

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}