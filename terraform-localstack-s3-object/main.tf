provider "aws" {
  region = "us-west-2"
  access_key = "0"
  secret_key = "0"
  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_metadata_api_check = true
  s3_force_path_style = true
  # In order to Mock with localstack
  endpoints {
    iam = "http://localhost:4566"
    s3 = "http://localhost:4566"
    kms = "http://localhost:4566"
  }
}

resource "aws_kms_key" "kms-s3-files" {
  description             = "KMS key 1"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "my-json-files-bucket" {
  bucket = "my-json-files-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.my-json-files-bucket.id
  key    = "my-json-json-key"
  source = "./my-json.json"
  kms_key_id = aws_kms_key.kms-s3-files.arn
}
