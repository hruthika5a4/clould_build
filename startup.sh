#!/bin/bash
set -e

# Install Docker (Debian/Ubuntu COS)
if ! command -v docker >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
  systemctl enable docker
  systemctl start docker
fi

IMAGE="__IMAGE__"
docker rm -f static-web || true
docker run -d --restart=always --name static-web -p 80:80 "$IMAGE"
