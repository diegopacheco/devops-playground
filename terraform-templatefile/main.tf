locals{
  result = templatefile("${path.module}/backends.tpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
}

output "result" {
  value = "${local.result}"
}
