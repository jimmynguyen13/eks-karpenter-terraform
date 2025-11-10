terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-karpenter-demo"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}