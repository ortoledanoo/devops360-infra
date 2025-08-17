variable "cluster_name" {
  description = "Name of the Cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of the cluster"
  type        = string
}

variable "instance_types" {
  description = "Instance types for managed node group"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for worker nodes"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "List of subnet IDs for EKS control plane"
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

variable "ami_type" {
  description = "The AMI Type for Managed Node Group"
  type        = string
}

