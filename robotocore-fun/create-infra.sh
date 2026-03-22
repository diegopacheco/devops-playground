#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
export AWS_ACCESS_KEY_ID=123456789012
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

cd lambda
zip -j function.zip index.py
cd ..

cd infra
rm -rf .terraform terraform.tfstate terraform.tfstate.backup
tofu init
tofu apply -auto-approve
cd ..

ROLE_ARN=$(aws --endpoint-url=http://localhost:4566 iam get-role \
  --role-name lambda-execution-role --query 'Role.Arn' --output text 2>/dev/null)

aws --endpoint-url=http://localhost:4566 lambda delete-function \
  --function-name my-function 2>/dev/null

aws --endpoint-url=http://localhost:4566 lambda create-function \
  --function-name my-function \
  --runtime python3.12 \
  --handler index.handler \
  --role "$ROLE_ARN" \
  --zip-file fileb://lambda/function.zip > /dev/null

echo "Infrastructure created successfully!"
