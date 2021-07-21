data "external" "current_date" {
  program = ["/bin/bash", "${path.module}/script.sh"]
}