#!/bin/bash

# Install Docker (for Debian/Ubuntu-based COS images)
sudo apt-get update
sudo apt-get install -y docker.io

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Read the image name passed from Cloud Build
IMAGE="__IMAGE__"
echo "Starting container with image: $IMAGE"

# Run the Docker container
sudo docker run -d -p 80:80 "$IMAGE"
