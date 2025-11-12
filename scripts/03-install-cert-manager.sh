#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../k8s/karpenter"

echo "[INFO] Installing cert-manager..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml

