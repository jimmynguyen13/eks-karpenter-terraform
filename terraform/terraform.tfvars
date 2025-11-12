aws_region        = "us-east-1"
cluster_name      = "eks-karpenter-demo"
k8s_version       = "1.33"
karpenter_version = "0.16.3"
tf_state_bucket   = "terraform-state-bucket-karpenter-demo"

# Nodegroup defaults
instance_type = "t3.micro"
desired_size  = 2
min_size      = 1
max_size      = 3