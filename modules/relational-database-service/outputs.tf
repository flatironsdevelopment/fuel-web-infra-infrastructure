output "db_hostname" {
  value       =  module.db.db_instance_endpoint
  description = "The database hostname (endpoint) for staging. Will be 'N/A' if not created."
}

output "app_name" {
  value = var.app_name
}