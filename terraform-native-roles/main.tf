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

resource "aws_iam_policy_attachment" "my-policy-role-attachment" {
  name       = "my-policy-role-attachment"
  roles      = ["${aws_iam_role.my-role-trust.name}"]
  policy_arn = "${aws_iam_policy.my-policy.arn}"
}

resource "aws_iam_role" "my-role-trust" {
  name = "my-role-trust"
  assume_role_policy = "${data.aws_iam_policy_document.trust-policy-doc.json}"
}
data "aws_iam_policy_document" "trust-policy-doc" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::000000000000:role/deploy-role",
        "arn:aws:iam::000000000000:role/engineer-role"
      ]
    }
  }
}

resource "aws_iam_policy" "my-policy" {
  name = "my-policy"
  policy = "${data.aws_iam_policy_document.my-policy-doc.json}"
}
data "aws_iam_policy_document" "my-policy-doc" {
  statement {
    sid = "ReadOnly"
    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "ec2:Describe*",
      "ec2:Get*",
      "eks:DescribeCluster",
      "eks:DescribeUpdates",
      "eks:ListClusters",
      "eks:ListUpdates",
      "sqs:Get*",
      "sqs:List*",
      "sqs:Receive*"
    ]
    resources = [ "*" ]
  }
}