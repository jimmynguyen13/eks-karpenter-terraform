resource "kubernetes_namespace" "karpenter_ns" {
  metadata {
    name = var.karpenter_namespace
  }
}

resource "kubernetes_service_account" "karpenter" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.karpenter_ns.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter.arn
    }
    labels = {
      app = "karpenter"
    }
  }
}
