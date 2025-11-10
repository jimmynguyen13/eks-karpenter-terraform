# Create IAM role for Karpenter controller
data "aws_iam_policy_document" "karpenter_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "karpenter_controller" {
  name               = "karpenter-controller-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json
}


data "aws_iam_policy_document" "karpenter_policy" {
  statement {
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
      "iam:PassRole",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_policy" "karpenter_policy" {
  name   = "karpenter-policy-${var.cluster_name}"
  policy = data.aws_iam_policy_document.karpenter_policy.json
}


resource "aws_iam_role_policy_attachment" "karpenter_policy_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_policy.arn
}


# Create IAM OIDC Provider for IRSA
resource "aws_iam_openid_connect_provider" "oidc" {
  url            = module.eks.cluster_oidc_issuer_url
  client_id_list = ["sts.amazonaws.com"]
  # thumbprint_list = [module.eks.cluster_oidc_provider_thumbprint]
}
