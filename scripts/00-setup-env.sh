#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
export AWS_REGION="us-east-1"
export CLUSTER_NAME="eks-karpenter-demo"

echo "[INFO] Setting up AWS environment..."
aws sts get-caller-identity
aws configure set region "$AWS_REGION"

# echo "[INFO] Updating kubeconfig for cluster: $CLUSTER_NAME"
# aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION"

echo "[OK] Environment setup complete."
