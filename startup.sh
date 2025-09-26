#!/bin/bash
set -e

# Update package list and install Docker
apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

# Get the image name passed from Cloud Build
IMAGE="__IMAGE__"
if [[ -z "$IMAGE" ]]; then
  echo "ERROR: IMAGE variable is not set!"
  exit 1
fi

# Remove existing container if exists
docker rm -f static-web || true

# Run the container
docker run -d \
  --restart=always \
  --name static-web \
  -p 80:80 \
  "$IMAGE"

echo "✅ Docker container running with image $IMAGE"
