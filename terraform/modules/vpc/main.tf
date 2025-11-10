module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 4.0"
  name            = var.cluster_name
  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
