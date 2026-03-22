#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

cd infra
tofu destroy -auto-approve
cd ..

echo "Infrastructure destroyed successfully!"
