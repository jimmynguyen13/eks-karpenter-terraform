#!/bin/bash
set -euo pipefail

MANIFEST_DIR="$(dirname "$0")/../k8s/karpenter"

echo "Applying Karpenter manifests from: ${MANIFEST_DIR}"

# Check Karpenter namespace
if ! kubectl get ns karpenter >/dev/null 2>&1; then
  echo "Namespace 'karpenter' not found — creating..."
  kubectl create ns karpenter
else
  echo "Namespace 'karpenter' exists."
fi

# Ensure Karpenter controller is running
echo "Checking Karpenter controller status..."
if ! kubectl get pods -n karpenter | grep -q karpenter; then
  echo "Karpenter controller not found! Please deploy Karpenter via Terraform first."
  echo "Run: terraform apply -target=module.karpenter"
  exit 1
else
  echo "Karpenter controller detected."
fi

# Apply provisioner manifests
for file in ${MANIFEST_DIR}/*.yaml; do
  echo "Applying manifest: ${file}"
  kubectl apply -f "${file}"
done

# Verify resources
echo
echo "Verifying Karpenter resources..."
kubectl get provisioners
kubectl get awsnodetemplates

echo
echo "All Karpenter manifests applied successfully!"
