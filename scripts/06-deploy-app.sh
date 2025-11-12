#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../k8s"

echo "[INFO] Deploying Node.js app..."
kubectl apply -f app/deployment.yaml
kubectl apply -f app/service.yaml
kubectl apply -f app/hpa.yaml

echo "[INFO] Deploying NGINX ingress controller and TLS..."
kubectl apply -f ingress-nginx/ingress.yaml
kubectl apply -f ingress-nginx/nginx-hpa.yaml

echo "[INFO] Waiting for app pods to be ready..."
kubectl rollout status deployment nodejs-app --timeout=180s

echo "[OK] Application deployed successfully."
