#!/bin/bash
set -e

DOMAIN=${1:-eks-karpenter-demo.com}
NAMESPACE=${2:-default}
SECRET_NAME=${3:-tls-secret}
CERT_DIR="$(dirname "$0")/../k8s/certs"

echo "Preparing certs directory..."
mkdir -p "${CERT_DIR}"
cd "${CERT_DIR}"

if [[ ! -f "tls.crt" || ! -f "tls.key" ]]; then
  echo "Generating new self-signed certificate for CN=${DOMAIN} ..."
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout tls.key \
    -out tls.crt \
    -subj "/CN=${DOMAIN}/O=DemoApp"
  echo "Certificate and key generated: tls.crt / tls.key"
else
  echo "Existing certs found — skipping OpenSSL generation."
fi

cd ..

echo "Creating TLS secret '$SECRET_NAME' in namespace '$NAMESPACE'..."

kubectl delete secret $SECRET_NAME -n $NAMESPACE --ignore-not-found >/dev/null 2>&1
kubectl create secret tls "${SECRET_NAME}" \
  --cert="${CERT_DIR}/tls.crt" \
  --key="${CERT_DIR}/tls.key" \
  -n "${NAMESPACE}"

kubectl get secret $SECRET_NAME -n $NAMESPACE
echo "TLS secret created successfully."
