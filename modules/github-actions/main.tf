locals {
  workflow_dir  = var.kubernetes ? "eks" : "ecs"
  workflow_path = "${path.module}/github-workflows-${local.workflow_dir}/"
}

resource "github_repository_file" "tests" {
  repository          = var.github_repo_name
  branch              = "workflow-creation"
  file                = ".github/workflows/tests.yaml"
  content             = file("${path.module}/github-workflows-app/tests.yml")
  commit_message      = "Adding tests for GitHub workflow"
  commit_author       = "Terraform User"
  commit_email        = "terraform@admin.com"
  overwrite_on_create = true
}

resource "github_repository_file" "deployment_file" {
  for_each = { for par in var.apps : par.app_name => par }

  file = ".github/workflows/${each.value.app_name}.yaml"
  content = replace(replace(replace(replace(replace(
    file("${local.workflow_path}/build_and_deploy.yml"),
    "REPLACEME", each.value.app_name
  ), "DOCKERFILE", each.value.dockerfile), "BUILDARGS", each.value.build_env),
  "BRANCHREPLACE", each.value.branch), "SECRETNAME", "${each.value.app_name}-secrets")

  repository          = var.github_repo_name
  branch              = "workflow-creation"
  commit_message      = "Adding ${each.value.app_name} deployment for GitHub workflows"
  commit_author       = "Terraform User"
  commit_email        = "terraform@admin.com"
  overwrite_on_create = true
}

resource "github_repository_file" "worker_deployment_file" {
  for_each = { for par in var.workers : par.app_name => par }

  file = ".github/workflows/${each.value.worker_name}.yaml"
  content = replace(
    replace(
      replace(
        replace(
          replace(
            file("${local.workflow_path}/build_and_deploy.yml"),
            "REPLACEME", "${each.value.worker_name}"
          ), 
          "DOCKERFILE", each.value.dockerfile
        ), 
        "BRANCHREPLACE", each.value.branch
      ), 
    "BUILDARGS", each.value.build_env
    ),
    "SECRETNAME", "${each.value.app_name}-secrets"
  )

  repository          = var.github_repo_name
  branch              = "workflow-creation"
  commit_message      = "Adding ${each.value.worker_name} deployment for GitHub workflows"
  commit_author       = "Terraform User"
  commit_email        = "terraform@admin.com"
  overwrite_on_create = true
}
