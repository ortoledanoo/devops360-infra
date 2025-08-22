# Main Variables
variable "environment" {
  description = "The environment"
  type        = string
}

variable "project_name" {
  description = "The Project name"
  type        = string
}

variable "cluster_name" {
  description = "The EKS Cluster name"
  type        = string
}

variable "region" {
  description = "The Region the app will provision"
  type        = string
}

variable "cidr_block" {
  description = "The VPC CIDR Block "
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR Of public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR Of private subnets"
  type        = list(string)
}

# EKS Variables

variable "cluster_version" {
  description = "The Managed node group AMI"
  type        = string
}

variable "ami_type" {
  description = "The Managed node group AMI"
  type        = string
}

variable "instance_types" {
  description = "Instance types for managed node group"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of nodes in the managed node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes in the managed node group"
  type        = number
  default     = 10
}

variable "desired_size" {
  description = "Desired number of nodes in the managed node group"
  type        = number
  default     = 2
}

# App Variables

variable "service_type" {
  description = "K8S Service Type"
  type        = string
}

variable "image_name" {
  description = "The App image name"
  type        = string
}


