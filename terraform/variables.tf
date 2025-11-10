variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-karpenter-demo"
}


variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}


variable "tf_state_bucket" {
  description = "S3 bucket for terraform state (optional)"
  type        = string
  default     = "terraform-state-bucket-karpenter-demo"
}