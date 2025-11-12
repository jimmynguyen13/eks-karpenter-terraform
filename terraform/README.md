# Terraform EKS Karpenter Infrastructure

This documentation describes the directory structure and provides step-by-step instructions for using Terraform to manage EKS infrastructure with Karpenter.

## Directory Structure

```
terraform/
├── main.tf                 # Main file defining modules and resources
├── variables.tf             # Input variable definitions
├── terraform.tfvars        # Variable values
├── outputs.tf              # Output value definitions
├── providers.tf            # AWS, Kubernetes, and Helm provider configurations
├── versions.tf             # Terraform and provider version constraints
├── backend.tf              # Remote state configuration (S3 backend)
├── locals.tf               # Local values (CIDR, subnets, AZs)
├── modules/                # Directory containing reusable modules
│   ├── vpc/                # Module for creating VPC and subnets
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── eks/                # Module for creating EKS cluster
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── nodegroup/          # Module for creating EKS node group
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── karpenter/          # Module for creating Karpenter
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

## Module Descriptions

### 1. **VPC Module** (`modules/vpc/`)

- Creates VPC with CIDR block
- Creates public and private subnets across multiple Availability Zones
- Configures route tables and internet gateway

### 2. **EKS Module** (`modules/eks/`)

- Creates EKS cluster with specified Kubernetes version
- Configures cluster endpoint and networking
- Creates IAM role for EKS cluster

### 3. **Nodegroup Module** (`modules/nodegroup/`)

- Creates EKS managed node group
- Configures instance types, scaling (min/max/desired size)
- Uses Bottlerocket AMI
- Creates IAM role for worker nodes

### 4. **Karpenter Module** (`modules/karpenter/`)

- Creates IAM role for Karpenter controller
- Configures OIDC provider for EKS
- Assigns necessary policies for Karpenter

## Usage Guide

### Prerequisites

1. **Terraform**: Version >= 1.3.0
2. **AWS CLI**: Installed and configured with credentials
3. **kubectl**: For interacting with EKS cluster
4. **S3 Bucket**: Pre-created bucket for remote state (as configured in `backend.tf`)

### Step 1: Initial Configuration

#### 1.1. Verify AWS Credentials

```bash
aws sts get-caller-identity
```

#### 1.2. Configure Environment Variables

Edit the `terraform.tfvars` file:

```hcl
aws_region      = "us-east-1"
cluster_name    = "eks-karpenter-demo"
k8s_version     = "1.33"
instance_type   = "t3.micro"
desired_size    = 2
min_size        = 1
max_size        = 3
```

#### 1.3. Verify Backend Configuration

Ensure the S3 bucket in `backend.tf` exists:

```hcl
bucket = "terraform-state-bucket-karpenter-demo"
key    = "eks/terraform.tfstate"
region = "us-east-1"
```

### Step 2: Initialize Terraform

Initialize Terraform and download required providers:

```bash
cd terraform
terraform init
```

**Expected result**: Message "Terraform has been successfully initialized!"

### Step 3: Validate Configuration

Check Terraform syntax and configuration:

```bash
terraform validate
```

**Expected result**:

```
Success! The configuration is valid.
```

### Step 4: Format Code (Optional)

Format code for consistency:

```bash
terraform fmt -recursive
```

### Step 5: Plan - Preview Changes

Preview the resources that will be created:

```bash
terraform plan
```

**Save plan to file** (optional):

```bash
terraform plan -out=tfplan
```

### Step 6: Apply - Create Infrastructure

Apply changes to create infrastructure:

```bash
terraform apply
```

Or if you saved the plan:

```bash
terraform apply tfplan
```

**Expected result**:

```
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```

#### 6.1. Apply with auto-approve

```bash
terraform apply -auto-approve
```

### Step 7: Verify Infrastructure

#### 7.1. Check EKS Cluster

```bash
aws eks list-clusters --region us-east-1
```

#### 7.2. Configure kubectl

```bash
aws eks update-kubeconfig --name eks-karpenter-demo --region us-east-1
```

Or use output from Terraform:

```bash
terraform output kubeconfig_command
```

#### 7.3. Check Nodes

```bash
kubectl get nodes
```

#### 7.4. Check Node Groups

```bash
aws eks describe-nodegroup --cluster-name eks-karpenter-demo --nodegroup-name core --region us-east-1
```

### Step 8: Destroy - Remove Infrastructure

#### 8.1. Preview Resources to be Deleted

```bash
terraform plan -destroy
```

#### 8.2. Destroy Infrastructure

```bash
terraform destroy
```

#### 8.3. Destroy with auto-approve

```bash
terraform destroy -auto-approve
```
