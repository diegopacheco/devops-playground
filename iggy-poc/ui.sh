#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

dc up -d iggy ui >/dev/null
wait_iggy
wait_ui

if command -v open >/dev/null 2>&1; then
  open "$IGGY_UI/auth/sign-in"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$IGGY_UI/auth/sign-in"
fi

print_access
