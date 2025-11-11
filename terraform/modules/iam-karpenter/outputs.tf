output "karpenter_controller_role_arn" {
  value = aws_iam_role.karpenter_controller.arn
}

output "karpenter_controller_role_name" {
  value = aws_iam_role.karpenter_controller.name
}

output "karpenter_controller_role_policy_arn" {
  value = aws_iam_policy.karpenter_policy.arn
}