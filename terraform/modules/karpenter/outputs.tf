output "karpenter_role_arn" {
  description = "IAM Role ARN for Karpenter controller (IRSA)"
  value       = aws_iam_role.karpenter.arn
}

output "karpenter_service_account" {
  description = "Kubernetes ServiceAccount name for Karpenter"
  value       = "${kubernetes_namespace.karpenter_ns.metadata[0].name}/${kubernetes_service_account.karpenter.metadata[0].name}"
}

output "karpenter_helm_release" {
  description = "Helm release info for Karpenter"
  value       = helm_release.karpenter.name
}
