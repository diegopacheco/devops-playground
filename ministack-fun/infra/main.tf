terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    secretsmanager = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    s3             = "http://localhost:4566"
    sts            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    rds            = "http://localhost:4566"
  }
}

resource "aws_secretsmanager_secret" "app_config" {
  name = "ministack/app-config"
}

resource "aws_secretsmanager_secret_version" "app_config_value" {
  secret_id     = aws_secretsmanager_secret.app_config.id
  secret_string = jsonencode({
    username = "admin"
    password = "supersecret123"
    api_key  = "mk-abc123def456"
  })
}

resource "aws_sqs_queue" "app_queue" {
  name                       = "ministack-app-queue"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "ministack-app-bucket"
}

resource "aws_s3_object" "sample_data" {
  bucket  = aws_s3_bucket.app_bucket.id
  key     = "data/sample.json"
  content = jsonencode({
    message = "Hello from Ministack S3"
    version = "1.0.0"
    items   = ["alpha", "bravo", "charlie"]
  })
}

resource "aws_kinesis_stream" "app_stream" {
  name             = "ministack-app-stream"
  shard_count      = 1
  retention_period = 48
}

resource "aws_db_instance" "app_db" {
  identifier           = "ministack-app-db"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "appdb"
  username             = "dbadmin"
  password             = "dbpassword123"
  skip_final_snapshot  = true
}


output "secret_arn" {
  value = aws_secretsmanager_secret.app_config.arn
}

output "queue_url" {
  value = aws_sqs_queue.app_queue.url
}

output "bucket_name" {
  value = aws_s3_bucket.app_bucket.id
}

output "kinesis_stream_name" {
  value = aws_kinesis_stream.app_stream.name
}

output "rds_endpoint" {
  value = aws_db_instance.app_db.endpoint
}

