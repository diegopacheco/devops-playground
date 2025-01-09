terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.16"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "nginx" {
  name    = "nginx"
  image   = "nginx:1"
  restart = "unless-stopped"
}

output "nginx_address" {
  value = "http://localhost"
}