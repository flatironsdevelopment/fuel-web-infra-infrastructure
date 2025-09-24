resource "aws_secretsmanager_secret" "secret" {
  name = "${var.project_name}_secrets"
  description = "Secret"
}
