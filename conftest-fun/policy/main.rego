package main

# Rule to check if AWS access key and secret key are hardcoded
deny[msg] {
  input.provider.aws.access_key != ""
  msg = "AWS access key should not be hardcoded"
}

deny[msg] {
  input.provider.aws.secret_key != ""
  msg = "AWS secret key should not be hardcoded"
}

# Rule to check if security group allows all inbound traffic
deny[msg] {
  input.resource.aws_security_group[_].ingress[_].cidr_blocks[_] == "0.0.0.0/0"
  msg = "Security group allows all inbound traffic"
}

# Rule to check if security group allows all outbound traffic
deny[msg] {
  input.resource.aws_security_group[_].egress[_].cidr_blocks[_] == "0.0.0.0/0"
  msg = "Security group allows all outbound traffic"
}

# Rule to check if S3 bucket is publicly accessible
deny[msg] {
  input.resource.aws_s3_bucket[_].acl == "public-read-write"
  msg = "S3 bucket is publicly accessible"
}

# Rule to check if RDS instance is publicly accessible
deny[msg] {
  input.resource.aws_db_instance[_].publicly_accessible == true
  msg = "RDS instance is publicly accessible"
}

# Rule to check if RDS instance storage is not encrypted
deny[msg] {
  input.resource.aws_db_instance[_].storage_encrypted == false
  msg = "RDS instance storage is not encrypted"
}

# Rule to check if RDS instance uses plaintext password
deny[msg] {
  input.resource.aws_db_instance[_].password == "plaintextpassword"
  msg = "RDS instance uses plaintext password"
}
