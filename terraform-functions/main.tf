locals{
  json_data = jsondecode(file("${path.module}/data.json"))
  rs_capital = upper(local.json_data.RS)
  rj_capital = lookup(local.json_data, "RJ", "Rio de Janeiro")
  encoded_poa = base64encode(local.json_data.RS)
}

output "json" {
  value = "${local.json_data}"
}
output "rs-capital" {
  value = "Capital: ${local.rs_capital} Encoded: ${local.encoded_poa}"
}
output "rj-capital" {
  value = "${local.rj_capital}"
}
output "all-capitals" {
  value = "${values(local.json_data)}"
}