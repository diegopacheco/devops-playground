#!/bin/bash

echo "Flink UI is available at: http://localhost:30080"
echo ""
echo "Or use port-forward for alternative access:"
echo "kubectl port-forward -n flink svc/flink-jobmanager 8081:8081"
echo "Then visit: http://localhost:8081"
