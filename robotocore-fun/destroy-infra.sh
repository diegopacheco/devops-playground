#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
export AWS_ACCESS_KEY_ID=123456789012
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

aws --endpoint-url=http://localhost:4566 lambda delete-function \
  --function-name my-function 2>/dev/null

cd infra
tofu destroy -auto-approve
cd ..

echo "Infrastructure destroyed successfully!"
