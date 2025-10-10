provider "kubernetes" {
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "terraform-app"
  }
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "app-config"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    app_name    = "terraform-managed-app"
    environment = "production"
    version     = "1.0.0"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "nginx-app"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config.metadata[0].name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}
