#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../k6"

API_URL=$(kubectl get ingress nodejs-ingress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
if [[ -z "$API_URL" ]]; then
  echo "[ERROR] Ingress not ready or missing external hostname."
  exit 1
fi

echo "[INFO] Running k6 ramp-up test on $API_URL"
k6 run ramp-up.js --env API_URL="https://$API_URL/time"

echo "[OK] K6 load test completed."
