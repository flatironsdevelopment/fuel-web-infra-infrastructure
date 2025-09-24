resource "aws_secretsmanager_secret" "app" {
  name        = "${var.name}"
  description = "This is a ${var.name} secret"
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id     = aws_secretsmanager_secret.app.id
  secret_string = jsonencode(var.env_vars)
}