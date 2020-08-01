provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

locals {
  json_data = jsondecode(file("${path.module}/data.json"))
}

resource "aws_instance" "server" {
  for_each = local.json_data.my_instances

  ami           = "ami-a1b2c3d4w"
  instance_type = "t2.large"
  subnet_id     = each.key
  tags = {
    Name = "Server ${each.key}"
  }
}