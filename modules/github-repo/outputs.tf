
output "github_repo_url" {
  value = github_repository.infrastructure.ssh_clone_url
}

output "github_http_repo_url" {
  value = github_repository.infrastructure.http_clone_url
}

output "github_repo_url_app" {
  value = github_repository.application.ssh_clone_url
}

output "github_monorepo_url" {
  value = github_repository.application.ssh_clone_url
}

output "github_monorepo_name" {
  value = github_repository.application.name
}

output "github_infrastructure_full_name" {
  value = github_repository.infrastructure.full_name
}

output "github_infrastructure_name" {
  value = github_repository.infrastructure.name
}