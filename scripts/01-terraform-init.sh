#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../terraform"

echo "[INFO] Initializing Terraform..."
terraform fmt -recursive
terraform init -upgrade
terraform validate

echo "[OK] Terraform initialized successfully."
