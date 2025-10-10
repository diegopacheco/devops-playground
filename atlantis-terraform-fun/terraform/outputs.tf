output "namespace_name" {
  description = "The name of the created namespace"
  value       = kubernetes_namespace.app.metadata[0].name
}

output "deployment_name" {
  description = "The name of the nginx deployment."
  value       = kubernetes_deployment.app.metadata[0].name
}

output "service_name" {
  description = "The name of the nginx service"
  value       = kubernetes_service.app.metadata[0].name
}

output "configmap_data" {
  description = "ConfigMap data"
  value       = kubernetes_config_map.app_config.data
}
