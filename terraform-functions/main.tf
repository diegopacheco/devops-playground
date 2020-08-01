locals{
  json_data = jsondecode("{\"RS\": \"Porto Alegre\"}").RS
}

output "result" {
  value = "${local.json_data}"
}