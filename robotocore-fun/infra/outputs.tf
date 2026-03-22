output "s3_bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}

output "sqs_queue_url" {
  value = aws_sqs_queue.my_queue.url
}

output "sns_topic_arn" {
  value = aws_sns_topic.my_topic.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.my_function.function_name
}

output "opensearch_domain_endpoint" {
  value = aws_opensearch_domain.my_domain.endpoint
}

output "secret_name" {
  value = aws_secretsmanager_secret.my_secret.name
}
