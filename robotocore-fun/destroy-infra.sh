#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

cd infra
tofu state rm aws_lambda_function.my_function 2>/dev/null
tofu destroy -auto-approve
cd ..

AWS_ACCESS_KEY_ID=123456789012 AWS_SECRET_ACCESS_KEY=test \
  aws --endpoint-url=http://localhost:4566 --region us-east-1 \
  lambda delete-function --function-name my-function 2>/dev/null

echo "Infrastructure destroyed successfully!"
