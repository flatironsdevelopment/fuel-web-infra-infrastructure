resource "random_string" "rails_secret_key_base" {
  length  = 64
  upper   = true
  lower   = true
  numeric  = true
  special = false

  keepers = {
    constant = "rails_secret_key_base"
  }
}

resource "random_string" "rails_encryption_password" {
  length  = 32
  upper   = true
  lower   = true
  numeric  = true
  special = false

  keepers = {
    constant = "rails_encryption_password"
  }
}

resource "random_string" "nest_encryption_password" {
  length  = 32
  upper   = true
  lower   = true
  numeric  = true
  special = false

  keepers = {
    constant = "nest_encryption_password"
  }
}
