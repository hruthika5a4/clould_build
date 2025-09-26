#!/bin/bash
set -e

exec > >(tee /var/log/startup-script.log) 2>&1
echo "=== Startup script started at $(date) ==="

# --- Install Docker if not present ---
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  apt-get update -y
  apt-get install -y ca-certificates curl gnupg lsb-release

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  systemctl enable docker
  systemctl start docker
fi

# --- Authenticate Docker with Artifact Registry ---
echo "Configuring Docker auth..."
gcloud auth configure-docker us-central1-docker.pkg.dev --quiet

# --- Image passed from Cloud Build ---
IMAGE="__IMAGE__"
echo "Using image: $IMAGE"

# --- Remove old container ---
docker rm -f static-web || true

# --- Pull latest image ---
docker pull "$IMAGE"

# --- Run new container ---
docker run -d \
  --restart=always \
  --name static-web \
  -p 80:80 \
  "$IMAGE"

# --- Verify container responds ---
sleep 5
if ! curl -sf http://localhost:80/ > /dev/null; then
  echo "ERROR: Container not responding on port 80!"
  exit 1
fi

echo "✅ Container is running with image: $IMAGE"
