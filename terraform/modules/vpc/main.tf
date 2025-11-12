module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 6.0"
  name            = var.cluster_name
  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"          = local.name
  }

  tags = local.tags
}

locals {
  name = var.cluster_name
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
