locals {
  all_apps = merge(
    { for app in var.apps : app.app_name => app },
    { for worker in var.workers : worker.worker_name => worker }
  )
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.0"

  repository_name         = "${var.project_name}-application"
  repository_force_delete = true
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      for idx, app_key in zipmap(range(length(keys(local.all_apps))), keys(local.all_apps)) : {
        rulePriority = idx + 1
        description  = "Keep 5 most recent images with prefix '${app_key}'"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = [app_key]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
