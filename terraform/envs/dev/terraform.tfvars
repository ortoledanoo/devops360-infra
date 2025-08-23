# Main Variables
environment  = "dev"
project_name = "devops360"
cluster_name = "devops360-dev-eks"
region       = "il-central-1"
cidr_block   = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]

# EKS Variables
cluster_version = "1.32"
ami_type = "AL2_x86_64"
min_size = 2
max_size = 4
desired_size = 2
instance_types = ["t3.medium"]

# App Variables
service_type = "NodePort"
image_name = "ortoledanoo/devops360-app:latest"
aws_account_id = "585768175989"