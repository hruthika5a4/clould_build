# switch-to-green.sh
#!/bin/bash
gcloud compute forwarding-rules set-target web-rule \
    --target-http-proxy=proxy-green \
    --global
echo "Traffic switched to GREEN environment ✅"
