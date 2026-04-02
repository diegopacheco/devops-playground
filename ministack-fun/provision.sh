#!/bin/bash
cd infra
rm -rf .terraform terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
tofu init
tofu apply -auto-approve 2>&1
if [ $? -ne 0 ]; then
  echo "Importing existing resources..."
  SECRET_ARN=$(aws --endpoint-url=http://localhost:4566 --region us-east-1 secretsmanager list-secrets --query 'SecretList[?Name==`ministack/app-config`].ARN' --output text 2>/dev/null)
  [ -n "$SECRET_ARN" ] && tofu import aws_secretsmanager_secret.app_config "$SECRET_ARN" 2>/dev/null
  tofu import aws_s3_bucket.app_bucket ministack-app-bucket 2>/dev/null
  tofu import aws_kinesis_stream.app_stream ministack-app-stream 2>/dev/null
  tofu import aws_db_instance.app_db ministack-app-db 2>/dev/null
  tofu import aws_sqs_queue.app_queue http://localhost:4566/000000000000/ministack-app-queue 2>/dev/null
  tofu apply -auto-approve
fi
cd ..
