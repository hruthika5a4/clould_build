#!/bin/bash
IMAGE="us-central1-docker.pkg.dev/singular-object-464504-a3/artifact-repo/static-web:__DEPLOY_ENV__-__VERSION__-__BUILD_ID__"
echo "Starting container: $IMAGE"
docker run -d -p 80:80 $IMAGE
