locals {
  sa_full_name = "${var.karpenter_namespace}/${var.service_account_name}"
}

# IAM policy document (least privilege)
data "aws_iam_policy_document" "karpenter_policy" {
  statement {
    sid = "AllowEC2AndAutoScaling"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate",
      "ec2:DeleteLaunchTemplate",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeImages",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeTags",
      "ec2:CreateVolume",
      "ec2:AttachVolume",
      "iam:PassRole",
      "iam:CreateServiceLinkedRole",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "eks:DescribeNodegroup",
      "pricing:GetProducts",
      "sts:AssumeRole",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "karpenter" {
  name   = "karpenter-policy-${var.cluster_name}"
  policy = data.aws_iam_policy_document.karpenter_policy.json
}

# IAM Role for Karpenter (IRSA)
data "aws_iam_policy_document" "karpenter_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.cluster_oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values = ["system:serviceaccount:${var.karpenter_namespace}:${var.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "karpenter" {
  name               = "karpenter-controller-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume.json
  description        = "IAM role for Karpenter controller (IRSA)"
}

resource "aws_iam_role_policy_attachment" "karpenter_attach_policy" {
  role       = aws_iam_role.karpenter.name
  policy_arn = aws_iam_policy.karpenter.arn
}
