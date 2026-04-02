#!/bin/bash
echo "Testing /status endpoint..."
echo ""
curl -s http://localhost:8181/status | python3 -m json.tool
echo ""
echo "All services checked."
