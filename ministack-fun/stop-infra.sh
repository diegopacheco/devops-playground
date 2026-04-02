#!/bin/bash
cd infra
tofu destroy -auto-approve 2>/dev/null
cd ..
podman stop ministack 2>/dev/null
podman rm -f ministack 2>/dev/null
echo "Infrastructure stopped"
