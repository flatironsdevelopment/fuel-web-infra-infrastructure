output "rails_secret_key_base" {
  value     = random_string.rails_secret_key_base.result
  sensitive = true
}

output "rails_encryption_password" {
  value     = random_string.rails_encryption_password.result
  sensitive = true
}

output "nest_encryption_password" {
  value     = random_string.nest_encryption_password.result
  sensitive = true
}