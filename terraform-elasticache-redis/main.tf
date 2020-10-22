 
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
    elasticache = "http://localhost:51492"
  }
}

resource "aws_elasticache_cluster" "replica" {
  cluster_id           = "cluster-example"
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}
