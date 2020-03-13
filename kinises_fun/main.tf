provider "aws" {
  region  = "us-west-2"
}

resource "aws_kinesis_stream" "microservice_stream" {
  name             = "terraform-kinesis-stream"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "test"
  }
}
