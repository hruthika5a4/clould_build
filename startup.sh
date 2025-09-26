#!/bin/bash
set -xe

# Install Docker if missing
if ! command -v docker >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
  systemctl enable docker
  systemctl start docker
fi

# Pull your test image (change to your Artifact Registry image later)
docker rm -f static-web || true
docker run -d \
  --restart=always \
  --name static-web \
  -p 80:80 \
  httpd:2.4

# Debug logs
echo "Container started" > /tmp/startup.log
docker ps >> /tmp/startup.log
