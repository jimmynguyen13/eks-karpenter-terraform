resource "aws_eks_node_group" "core" {
  cluster_name    = var.cluster_name
  node_group_name = "core"
  node_role_arn   = aws_iam_role.core_node_role.arn
  subnet_ids      = var.private_subnets
  instance_types  = [var.instance_type]


  ami_type = "BOTTLEROCKET_x86_64"


  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }


  labels = { Role = "core" }
}

# Role for core nodegroup
resource "aws_iam_role" "core_node_role" {
  name               = "${var.cluster_name}-core-node-role"
  assume_role_policy = data.aws_iam_policy_document.core_assume_role.json
}


data "aws_iam_policy_document" "core_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "core_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.core_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "core_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.core_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_iam_role_policy_attachment" "core_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.core_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}