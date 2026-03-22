#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
cd lambda
zip -j function.zip index.py
cd ..

cd infra
tofu init
tofu apply -auto-approve
cd ..

echo "Infrastructure created successfully!"
