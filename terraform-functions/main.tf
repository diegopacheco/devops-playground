locals{
  json_data = jsondecode(file("${path.module}/data.json"))
  rs_capital = upper(local.json_data.RS)
}

output "json" {
  value = "${local.json_data}"
}
output "rs-capital" {
  value = "${local.rs_capital}"
}