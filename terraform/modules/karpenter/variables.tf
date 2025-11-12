variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "ARN of the OIDC provider for the cluster"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "karpenter_namespace" {
  description = "Namespace to install Karpenter into"
  type        = string
  default     = "karpenter"
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name for Karpenter"
  type        = string
  default     = "karpenter"
}

variable "karpenter_chart_version" {
  description = "Karpenter Helm chart version (if using chart repo)"
  type        = string
  default     = "0.35.0"
}

variable "karpenter_helm_repo" {
  description = "Helm repo URL for Karpenter chart"
  type        = string
  default     = "https://charts.karpenter.sh"
}
