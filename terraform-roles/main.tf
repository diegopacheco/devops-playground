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

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
              "sqs.amazonaws.com",
              "rds.amazonaws.com",
              "lambda.amazonaws.com"
          ]
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "policy" {
  name = "policy"
  role = "${aws_iam_role.ec2_role.id}"
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "sqs:CreateQueue",
          "sqs:DeleteQueue",
          "sqs:DeleteMessage",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "rds:CreateDBCluster",
          "rds:CreateDBInstance",
          "rds:DeleteDBCluster",
          "rds:DeleteDBInstance",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:InvokeFunction"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

output "aws_iam_role_details" {
    value = [
            "${aws_iam_role.ec2_role.id}",
            "${aws_iam_role.ec2_role.create_date}",
            "${aws_iam_role.ec2_role.arn}",
           ]
}
