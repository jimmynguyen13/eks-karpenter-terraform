#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../terraform"

read -p "WARNING: This will destroy ALL resources! Continue? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "[CANCELLED] Destroy aborted."
  exit 0
fi

terraform destroy -auto-approve

echo "[OK] All AWS resources destroyed successfully."
