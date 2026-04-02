#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR/app"
mvn clean package -DskipTests -q
java -Daws.cborEnabled=false -jar target/ministack-app-1.0.0.jar &
APP_PID=$!
echo $APP_PID > "$SCRIPT_DIR/.app.pid"
cd "$SCRIPT_DIR"
echo "App starting on http://localhost:8181"
while ! curl -s http://localhost:8181/status > /dev/null 2>&1; do
  sleep 1
done
echo "App is ready"
