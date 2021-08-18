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
  }
}

data "aws_iam_policy_document" "source" {
  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
  }
  statement {
    sid = "SidToOverride"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "source_json_example" {
  source_json = data.aws_iam_policy_document.source.json

  statement {
    sid = "SidToOverride"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::somebucket",
      "arn:aws:s3:::somebucket/*",
    ]
  }
}
