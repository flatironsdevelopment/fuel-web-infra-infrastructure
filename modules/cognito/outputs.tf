output "cognito_user_pool_id" {
  value       = aws_cognito_user_pool.staging.id 
  description = "The ID of the Cognito User Pool"
}

output "cognito_user_pool_client_id" {
  value       = aws_cognito_user_pool_client.staging.id 
  description = "The ID of the Cognito User Pool Client"
}

output "app_name" {
  value = var.app_name
}