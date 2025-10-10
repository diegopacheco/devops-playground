#!/bin/bash
set -e

echo "Watching terraform/ folder for changes..."
echo "Changes will trigger automatic terraform apply"
echo "Press Ctrl+C to stop"
echo ""

LAST_HASH=""

while true; do
  CURRENT_HASH=$(find terraform -type f -name "*.tf" -exec md5 {} \; 2>/dev/null | md5)

  if [ "$LAST_HASH" != "$CURRENT_HASH" ] && [ -n "$LAST_HASH" ]; then
    echo "Changes detected! Running terraform apply..."
    ./apply-terraform.sh <<< "yes"
    echo ""
  fi

  LAST_HASH=$CURRENT_HASH
  sleep 1
done
