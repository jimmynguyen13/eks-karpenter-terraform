#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===
AWS_REGION="us-east-1"
APP_NAME="nodejs-app"
VERSION_TAG="${1:-latest}"

# === STEP 1: CHECK AWS LOGIN ===
echo "[INFO] Checking AWS credentials..."
aws sts get-caller-identity >/dev/null

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO="${APP_NAME}"
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"

# === STEP 2: CREATE ECR REPOSITORY IF NEEDED ===
echo "[INFO] Ensuring ECR repository exists..."
aws ecr describe-repositories --repository-names "${ECR_REPO}" --region "${AWS_REGION}" >/dev/null 2>&1 || \
aws ecr create-repository --repository-name "${ECR_REPO}" --image-scanning-configuration scanOnPush=true --region "${AWS_REGION}"

# === STEP 3: LOGIN TO ECR ===
echo "[INFO] Logging into Amazon ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# === STEP 4: BUILD DOCKER IMAGE ===
echo "[INFO] Building Docker image for ${APP_NAME}:${VERSION_TAG} ..."
cd "$(dirname "$0")/../app"
docker build -t "${APP_NAME}:${VERSION_TAG}" .

# === STEP 5: TAG AND PUSH ===
docker tag "${APP_NAME}:${VERSION_TAG}" "${ECR_URI}:${VERSION_TAG}"

echo "[INFO] Pushing image to ${ECR_URI}:${VERSION_TAG} ..."
docker push "${ECR_URI}:${VERSION_TAG}"

# === STEP 6: OUTPUT RESULT ===
echo
echo "Image successfully pushed to ECR!"
echo "Image URI: ${ECR_URI}:${VERSION_TAG}"
echo
echo "You can now update your Kubernetes deployment with:"
echo "kubectl set image deployment/${APP_NAME} ${APP_NAME}=${ECR_URI}:${VERSION_TAG}"
