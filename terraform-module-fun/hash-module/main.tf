terraform {
  required_version = "~> 0.12"
  experiments      = [variable_validation]
}

locals {
  pass_hash = "${sha256(var.password)}"
}