resource "aws_cognito_user_pool" "staging" {
  name = var.app_name

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration {
    enabled = true
  }

  sms_authentication_message = "Your code is {####}"

  sms_configuration {
    external_id    = "exampleExternalID"
    sns_caller_arn = aws_iam_role.sns_role.arn
    sns_region     = var.aws_region
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }


  lambda_config {
    kms_key_id                     = aws_kms_key.staging.arn
    create_auth_challenge          = aws_lambda_function.staging.arn
    custom_message                 = aws_lambda_function.staging.arn
    define_auth_challenge          = aws_lambda_function.staging.arn
    post_authentication            = aws_lambda_function.staging.arn
    post_confirmation              = aws_lambda_function.staging.arn
    pre_authentication             = aws_lambda_function.staging.arn
    pre_sign_up                    = aws_lambda_function.staging.arn
    pre_token_generation           = aws_lambda_function.staging.arn
    user_migration                 = aws_lambda_function.staging.arn
    verify_auth_challenge_response = aws_lambda_function.staging.arn

    custom_email_sender {
      lambda_arn     = aws_lambda_function.staging.arn
      lambda_version = "V1_0"
    }

    custom_sms_sender {
      lambda_arn     = aws_lambda_function.staging.arn
      lambda_version = "V1_0"
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "given_name"
    required            = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = true
    name     = "family_name"
    required = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "phone_number"
    required            = true
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "staging" {
  name = var.app_name

  user_pool_id                  = aws_cognito_user_pool.staging.id
  generate_secret               = false
  refresh_token_validity        = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

resource "aws_cognito_user_pool_domain" "staging" {
  domain       = var.app_name
  user_pool_id = aws_cognito_user_pool.staging.id
}

resource "aws_lambda_permission" "staging" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.staging.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.staging.arn
}