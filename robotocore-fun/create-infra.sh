#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

cd lambda
zip -j function.zip index.py
cd ..

cd infra
rm -rf .terraform terraform.tfstate terraform.tfstate.backup
tofu init
tofu apply -auto-approve
cd ..

echo "Infrastructure created successfully!"
