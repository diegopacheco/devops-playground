#!/bin/bash
set -e

REGISTRY_UI_URL="http://localhost:30080"

echo "Opening Docker Registry UI in browser..."
echo "Registry UI: $REGISTRY_UI_URL"
echo "Registry API: http://localhost:30500"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
  open "$REGISTRY_UI_URL"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  xdg-open "$REGISTRY_UI_URL"
else
  echo "Please open $REGISTRY_UI_URL in your browser manually"
fi
