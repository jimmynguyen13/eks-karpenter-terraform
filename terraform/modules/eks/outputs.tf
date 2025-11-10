output "cluster_name" {
  value       = module.eks.cluster_id
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "cluster_oidc_issuer_url" {
  value       = module.eks.cluster_oidc_issuer_url
  description = "EKS cluster OIDC issuer URL"
}

# output "cluster_oidc_provider_thumbprint" {
#   value       = module.eks.cluster_oidc_provider_thumbprint
#   description = "EKS cluster OIDC provider thumbprint"
# }

# output "cluster_oidc_provider_arn" {
#   value       = module.eks.cluster_oidc_provider_arn
#   description = "EKS cluster OIDC provider ARN"
# }

# output "cluster_oidc_provider_id" {
#   value       = module.eks.cluster_oidc_provider_id
#   description = "EKS cluster OIDC provider ID"
# }