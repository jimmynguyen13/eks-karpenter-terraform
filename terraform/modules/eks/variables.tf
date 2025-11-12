variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-karpenter-demo"
}

variable "instance_type" {
  description = "Default instance type for nodegroup"
  type        = string
  default     = "t3.small"
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for the EKS cluster"
  type        = list(string)
}