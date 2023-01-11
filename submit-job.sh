#!/usr/bin/env bash

echo "Call job submit end point"
curl --fail -H "Content-Type: application/json" -XPOST "$MAAP_API_URL"/mas/build --data-binary @job-submission.json

