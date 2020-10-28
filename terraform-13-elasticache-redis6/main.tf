provider "aws" {
  region  = "us-west-2"
  profile = "${var.profile}"
  shared_credentials_file = "~/.aws/credentials" 
}

variable "profile" {
  type        = string
  default    = "default"
  description = "The AWS Profile"
}

locals {
  cluster_name = "elasticache-redis-cluster"
}

resource "aws_security_group" "rediscluster_sg" {
  name        = "${local.cluster_name}-sg"
  description = "${local.cluster_name}-sg"
  vpc_id      = "vpc-000000000" 
  ingress {
    description = "Redis PORT 6379"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.cluster_name}"
  }
}

resource "aws_elasticache_replication_group" "rediscluster" {
  replication_group_id          = "${local.cluster_name}"
  replication_group_description = "${local.cluster_name}"
  port                          = 6379
  node_type                     = "cache.m4.large"
  parameter_group_name          = "default.redis6.x.cluster.on"
  subnet_group_name             = "default-elasticache-subnet-group"
  automatic_failover_enabled    = true
  security_group_ids            = [aws_security_group.rediscluster_sg.id]
  cluster_mode {
    replicas_per_node_group = 1   // REPLICAS
    num_node_groups = 1           // SHARDS
  }
}

output "cluster_url" {
  value = "${aws_elasticache_replication_group.rediscluster.primary_endpoint_address}"
}
