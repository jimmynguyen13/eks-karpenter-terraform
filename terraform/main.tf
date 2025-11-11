module "vpc" {
  source          = "./modules/vpc"
  cidr            = local.cidr
  azs             = local.azs
  public_subnets  = local.public_subnet_cidrs
  private_subnets = local.private_subnet_cidrs
}


module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  k8s_version     = var.k8s_version
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "iam-karpenter" {
  source                  = "./modules/iam-karpenter"
  cluster_name            = module.eks.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
}

module "nodegroup" {
  source          = "./modules/nodegroup"
  cluster_name    = module.eks.cluster_name
  private_subnets = module.vpc.private_subnets
  instance_type   = var.instance_type
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
}

# expose cluster data for providers
data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}


data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}