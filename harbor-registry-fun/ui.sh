#!/bin/bash
set -e

HARBOR_URL="http://localhost:8080"
PORT=8080

echo "Setting up port-forward to Harbor UI..."
echo "Harbor UI will be accessible at: $HARBOR_URL"
echo "Username: admin"
echo "Password: Harbor12345"
echo ""

kubectl port-forward -n harbor svc/harbor ${PORT}:80 > /dev/null 2>&1 &
PORT_FORWARD_PID=$!

for i in {1..10}; do
  if curl -s http://localhost:${PORT} > /dev/null 2>&1; then
    echo "Port-forward established"
    break
  fi
  sleep 1
done

echo "Opening Harbor UI in browser..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  open "$HARBOR_URL"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  xdg-open "$HARBOR_URL"
else
  echo "Please open $HARBOR_URL in your browser manually"
fi

echo ""
echo "Port-forward running in background (PID: $PORT_FORWARD_PID)"
echo "To stop: kill $PORT_FORWARD_PID"
