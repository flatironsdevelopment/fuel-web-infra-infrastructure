
resource "github_repository" "application" {
  name        = "${var.project_name}-monorepo"
  description = "Code repository for backend application"
  auto_init   = true
  visibility  = "public"

  lifecycle {
    ignore_changes = [
      visibility,
    ]
  }
}

resource "github_repository" "infrastructure" {
  name        = "${var.project_name}-infrastructure"
  description = "Code repository for backend infrastructure"
  auto_init   = false
  visibility  = "public"

  lifecycle {
    ignore_changes = [
      visibility,
    ]
  }
}

resource "github_branch" "dev" {
  repository = github_repository.application.name
  branch     = "dev"
  depends_on = [github_repository.application]
}

resource "github_branch" "staging" {
  repository = github_repository.application.name
  branch     = "staging"
  depends_on = [github_repository.application]
}

resource "github_branch" "main" {
  repository = github_repository.application.name
  branch     = "main"
  depends_on = [github_repository.application]
}

resource "github_branch" "workflow-creation" {
  repository = github_repository.application.name
  branch     = "workflow-creation"
  depends_on = [github_repository.application]
}

locals {
  required_checks = ["Title matches Jira Issue"]
}

resource "github_branch_protection" "main" {
  repository_id    = github_repository.application.node_id
  pattern          = "main"
  enforce_admins   = false
  allows_deletions = false

  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews = true
    restrict_dismissals   = true
  }

  required_status_checks {
    strict   = true
    contexts = local.required_checks
  }

  depends_on = [github_repository.application]
}

# Branch protection for staging
resource "github_branch_protection" "staging" {
  repository_id  = github_repository.application.node_id
  pattern        = "staging"
  enforce_admins = false
  allows_deletions = false

  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
  }

  required_status_checks {
    strict   = true
    contexts = local.required_checks
  }

  depends_on = [github_repository.application]
}

# Branch protection for dev
resource "github_branch_protection" "dev" {
  repository_id  = github_repository.application.node_id
  pattern        = "dev"
  enforce_admins = false
  allows_deletions = false

  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
  }

  required_status_checks {
    strict   = true
    contexts = local.required_checks
  }

  depends_on = [github_repository.application]
}