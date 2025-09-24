#!/bin/bash
gcloud compute forwarding-rules set-target web-rule \
    --target-http-proxy=proxy-blue \
    --global
echo "Traffic switched to BLUE ✅"
