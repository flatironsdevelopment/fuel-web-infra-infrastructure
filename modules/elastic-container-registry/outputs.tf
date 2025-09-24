output "repository_url" {
  description = "The URL of the repository."
  value = module.ecr.repository_url
}

output "registry_id" {
  description = "The registry ID"
  value = module.ecr.repository_registry_id
}
