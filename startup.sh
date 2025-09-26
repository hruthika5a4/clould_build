#!/bin/bash
set -e

# --- Install Docker if not present ---
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  apt-get update -y
  apt-get install -y docker.io
  systemctl enable docker
  systemctl start docker
fi

# --- Authenticate Docker with GCP Artifact Registry ---
gcloud auth configure-docker us-central1-docker.pkg.dev --quiet

# --- Get the image name passed from Cloud Build ---
IMAGE="__IMAGE__"
if [[ -z "$IMAGE" ]]; then
  echo "ERROR: IMAGE variable is not set!"
  exit 1
fi

echo "Starting container with image: $IMAGE"

# --- Remove existing container if it exists ---
docker rm -f static-web || true

# --- Run the Docker container ---
docker run -d \
  --restart=always \
  --name static-web \
  -p 80:80 \
  "$IMAGE"

# --- Verify container is running ---
sleep 5
if ! curl -sf http://localhost:80/ > /dev/null; then
  echo "ERROR: Container not responding on port 80!"
  exit 1
fi

echo "✅ Docker container is running with image: $IMAGE"
