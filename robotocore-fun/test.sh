#!/bin/bash
echo "Checking robotocore health..."
curl -s http://localhost:4566/_robotocore/health | python3 -m json.tool

echo ""
echo "Checking S3 buckets..."
AWS_ACCESS_KEY_ID=123456789012 AWS_SECRET_ACCESS_KEY=test \
  aws --endpoint-url=http://localhost:4566 s3 ls

echo ""
echo "Checking SQS queues..."
AWS_ACCESS_KEY_ID=123456789012 AWS_SECRET_ACCESS_KEY=test \
  aws --endpoint-url=http://localhost:4566 sqs list-queues --region us-east-1

echo ""
echo "Checking SNS topics..."
AWS_ACCESS_KEY_ID=123456789012 AWS_SECRET_ACCESS_KEY=test \
  aws --endpoint-url=http://localhost:4566 sns list-topics --region us-east-1

echo ""
echo "Checking Lambda functions..."
AWS_ACCESS_KEY_ID=123456789012 AWS_SECRET_ACCESS_KEY=test \
  aws --endpoint-url=http://localhost:4566 lambda list-functions --region us-east-1

echo ""
echo "Running Java application..."
./run.sh
