#!/bin/bash
IMAGE="us-central1-docker.pkg.dev/singular-object-464504-a3/artifact-repo/static-web:${DEPLOY_ENV}-${_VERSION}-${BUILD_ID}"
echo "Starting container: $IMAGE"
docker run -d -p 80:80 $IMAGE
