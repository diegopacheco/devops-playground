#!/bin/bash
if [ -f .app.pid ]; then
  kill $(cat .app.pid) 2>/dev/null
  rm -f .app.pid
  echo "App stopped"
else
  PID=$(lsof -ti :8181 2>/dev/null)
  if [ -n "$PID" ]; then
    kill $PID 2>/dev/null
    echo "App stopped"
  else
    echo "No running app found"
  fi
fi
