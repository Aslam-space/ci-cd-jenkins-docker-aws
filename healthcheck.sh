#!/bin/bash
# ==========================================
# Container Healthcheck Script
# Checks if Nginx is serving content
# ==========================================

# URL to check
URL="http://localhost/"

# Timeout & retry configuration
RETRIES=3
SLEEP_INTERVAL=2

STATUS=1

for i in $(seq 1 $RETRIES); do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL) || true
    if [[ "$HTTP_CODE" == "200" ]]; then
        STATUS=0
        break
    fi
    sleep $SLEEP_INTERVAL
done

if [[ $STATUS -eq 0 ]]; then
    echo "✅ Container is healthy. HTTP $HTTP_CODE"
    exit 0
else
    echo "❌ Container is unhealthy. Last HTTP code: $HTTP_CODE"
    exit 1
fi
