#!/bin/bash

set -e

GRAFANA_URL="http://grafana:3000"
GRAFANA_USER="admin"
GRAFANA_PASSWORD="admin"

echo "Waiting for Grafana to be ready..."
sleep 15

echo "Testing grafanactl config check..."
docker-compose exec grafanactl sh -c "
  export PATH=\$PATH:/root/go/bin
  export GRAFANA_SERVER='${GRAFANA_URL}'
  export GRAFANA_ORG_ID='1'
  export GRAFANA_USER='${GRAFANA_USER}'
  export GRAFANA_PASSWORD='${GRAFANA_PASSWORD}'

  grafanactl config check
"

echo ""
echo "Fetching all dashboards..."
docker-compose exec grafanactl sh -c "
  apk add --no-cache curl jq

  DASHBOARDS=\$(curl -f -s -u ${GRAFANA_USER}:${GRAFANA_PASSWORD} ${GRAFANA_URL}/api/search?type=dash-db)

  echo 'Dashboard validation results:'
  echo \$DASHBOARDS | jq .

  DASHBOARD_COUNT=\$(echo \$DASHBOARDS | jq '. | length')
  echo ''
  echo 'Total dashboards found:' \$DASHBOARD_COUNT

  if [ \$DASHBOARD_COUNT -gt 0 ]; then
    echo 'Dashboard validation: PASSED'
    exit 0
  else
    echo 'Dashboard validation: FAILED (no dashboards found)'
    exit 1
  fi
"

echo "Dashboard validation completed successfully"