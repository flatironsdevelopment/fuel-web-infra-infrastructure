resource "github_actions_secret" "access_key" {
  repository      = var.github_repo_name
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id

  lifecycle {
    ignore_changes = all
  }
}

resource "github_actions_secret" "region" {
  repository      = var.github_repo_name
  secret_name     = "AWS_REGION"
  plaintext_value = var.aws_region

  lifecycle {
    ignore_changes = all
  }
}

resource "github_actions_secret" "secret_key" {
  repository      = var.github_repo_name
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key

  lifecycle {
    ignore_changes = all
  }
}

resource "github_actions_secret" "repo" {
  repository      = var.github_repo_name
  secret_name     = "REPO_NAME"
  plaintext_value = var.github_infrastructure_full_name

  lifecycle {
    ignore_changes = all
  }
}

resource "github_actions_secret" "token" {
  repository      = var.github_repo_name
  secret_name     = "ACCESS_TOKEN"
  plaintext_value = var.github_token

  lifecycle {
    ignore_changes = all
  }
}

resource "github_actions_secret" "environment" {
  repository      = var.github_repo_name
  secret_name     = "ENVIRONMENT"
  plaintext_value = var.project_name

  lifecycle {
    ignore_changes = all
  }
}

resource "github_actions_secret" "project_name" {
  repository      = var.github_repo_name
  secret_name     = "PROJECT_NAME"
  plaintext_value = var.project_name

  lifecycle {
    ignore_changes = all
  }
}