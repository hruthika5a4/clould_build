#!/bin/bash
set -e

# Get commit SHA from Cloud Build
COMMIT_SHA="$1"
if [[ -z "$COMMIT_SHA" ]]; then
  echo "ERROR: COMMIT_SHA not provided!"
  exit 1
fi

PROJECT_ID=$(gcloud config get-value project)
MIG_NAME="web-1-mig"
ZONE="us-central1-a"
TEMPLATE="web-template-$COMMIT_SHA-$(date +%s)"
IMAGE="us-central1.pkg.dev/$PROJECT_ID/artifact-repo/web-app:$COMMIT_SHA"

echo "Creating instance template: $TEMPLATE"

# Create instance template using Container-Optimized OS
gcloud compute instance-templates create "$TEMPLATE" \
  --machine-type=e2-micro \
  --image-family=cos-stable \
  --image-project=cos-cloud \
  --boot-disk-size=10GB \
  --tags=http-server \
  --metadata="gce-container-declaration=spec:
  containers:
    - name: web-app
      image: $IMAGE
      stdin: false
      tty: false
  restartPolicy: Always"

echo "Starting rolling update in MIG $MIG_NAME"
gcloud compute instance-groups managed rolling-action start-update "$MIG_NAME" \
  --version template="$TEMPLATE" \
  --zone "$ZONE" \
  --type=proactive \
  --max-surge=1 \
  --max-unavailable=0

# Cleanup old templates (keep last 3)
old_templates=$(gcloud compute instance-templates list \
  --filter="name~web-template-" \
  --sort-by=~creationTimestamp \
  --format="value(name)" | tail -n +4)

for t in $old_templates; do
  echo "Deleting old template: $t"
  gcloud compute instance-templates delete "$t" --quiet
done
