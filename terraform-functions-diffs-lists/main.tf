locals{
  json_data = jsondecode(file("${path.module}/data.json"))
  capitals = toset(values(tomap(local.json_data.capitals)))
  suck_capitals = toset(values(tomap(local.json_data.worst_cities)))
  capitals_that_dont_suck = setsubtract(local.capitals, local.suck_capitals)
}

output "json" {
  value = "${local.json_data}"
}
output "capitals" {
  value = "${tostring( join(", ",local.suck_capitals))}"
}
output "capitals-suck" {
  value = "${tostring( join(", ",local.suck_capitals))}"
}
output "capitals-dont-suck" {
  value = "${tostring( join(", ",local.capitals_that_dont_suck))}"
}