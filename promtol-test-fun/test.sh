#!/bin/bash

set -e

echo "Running Prometheus alert rule tests..."
promtool test rules alerts_test.yml

echo ""
echo "Validating Prometheus configuration..."
promtool check config prometheus.yml

echo ""
echo "Validating alert rules..."
promtool check rules alerts.yml

echo ""
echo "All tests passed successfully!"