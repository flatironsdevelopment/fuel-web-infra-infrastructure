locals {
  infra_vars = jsondecode(file("../../config.json"))
}

resource "aws_s3_bucket" "terraform_backend" {
  bucket = "${var.project_name}-infrastructure-tf"
  force_destroy = true
}

resource "aws_secretsmanager_secret" "this" {
  name        = "${var.project_name}-infrastructure-variables"
  description = "This is a ${var.project_name} secret"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(local.infra_vars)
}
