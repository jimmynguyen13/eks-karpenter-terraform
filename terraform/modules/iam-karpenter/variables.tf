variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-karpenter-demo"
}

variable "cluster_oidc_issuer_url" {
  description = "EKS OIDC Issuer URL"
  type        = string
}