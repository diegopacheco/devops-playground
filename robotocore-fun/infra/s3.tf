resource "aws_s3_bucket" "data_bucket" {
  bucket        = "my-data-bucket"
  force_destroy = true
}
