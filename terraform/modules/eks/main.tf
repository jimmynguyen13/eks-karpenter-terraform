module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"


  cluster_name                  = var.cluster_name
  cluster_version               = var.k8s_version
  vpc_id                        = var.vpc_id
  subnet_ids                    = var.private_subnets
  control_plane_subnet_ids      = var.private_subnets
  cluster_enabled_log_types     = ["api", "audit", "authenticator"]
  bootstrap_self_managed_addons = true
}