module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "~> 21.0"
  name               = var.cluster_name
  kubernetes_version = var.k8s_version

  vpc_id                                   = var.vpc_id
  subnet_ids                               = var.private_subnets
  control_plane_subnet_ids                 = var.private_subnets
  enable_cluster_creator_admin_permissions = true
  endpoint_public_access                   = true

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = [var.instance_type]

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      labels = {
        "karpenter.sh/controller" = "true"
      }
    }
  }

  node_security_group_tags = merge(local.tags, {
    "karpenter.sh/discovery" = local.name
  })
}

locals {
  name = "eks-karpenter-demo"
  tags = {
    Environment = "dev"
    Name        = local.name
  }
}