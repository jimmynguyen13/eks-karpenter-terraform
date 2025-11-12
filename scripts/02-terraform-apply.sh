#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../terraform"

echo "[INFO] Running Terraform plan..."
terraform plan -out=tfplan

read -p "Apply infrastructure changes? (y/n): " CONFIRM
if [[ "$CONFIRM" == "y" ]]; then
  terraform apply tfplan
  echo "[OK] Infrastructure applied successfully."
else
  echo "[CANCELLED] Apply aborted."
fi
