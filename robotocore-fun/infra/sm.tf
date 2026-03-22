resource "aws_secretsmanager_secret" "my_secret" {
  name                    = "my-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "my_secret_value" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "change-me"
  })
}
