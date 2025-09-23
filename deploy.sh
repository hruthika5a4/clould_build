#!/bin/bash
set -e

COMMIT_SHA="$1"
TEMPLATE="web-template-$COMMIT_SHA"
MIG_NAME="web-1-mig"
ZONE="us-central1-a"

# Create COS instance template with container
gcloud compute instance-templates create "$TEMPLATE" \
  --machine-type=e2-micro \
  --image-family=cos-stable \
  --image-project=cos-cloud \
  --boot-disk-size=10GB \
  --tags=http-server \
  --metadata="gce-container-declaration=spec:
  containers:
    - name: web-app
      image: us-central1-docker.pkg.dev/$PROJECT_ID/artifact-repo/web-app:$COMMIT_SHA
      stdin: false
      tty: false
  restartPolicy: Always"

# Rolling update
gcloud compute instance-groups managed rolling-action start-update "$MIG_NAME" \
  --version template="$TEMPLATE" \
  --zone "$ZONE"
