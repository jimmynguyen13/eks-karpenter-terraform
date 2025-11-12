# Use Helm provider (assumes kubernetes provider configured in root)
resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = var.karpenter_helm_repo
  chart      = "karpenter"
  version    = var.karpenter_chart_version
  namespace  = kubernetes_namespace.karpenter_ns.metadata[0].name

  recreate_pods = true
  force_update   = true

  # Helm values - disable SA creation and use the IRSA-created SA:
  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = var.service_account_name
      }
      clusterName     = var.cluster_name
      clusterEndpoint = var.cluster_endpoint
      aws = {
        clusterEndpoint = var.cluster_endpoint
      }
      # Optional controller settings
      controller = {
        resources = {
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.karpenter,
    aws_iam_role_policy_attachment.karpenter_attach_policy
  ]
}
