resource "aws_iam_role" "cognito" {
  name = "lambda_cognito_execution_role_${var.app_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_lambda_function" "staging" {
  function_name = "${var.app_name}-postConfirmationTrigger"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.cognito.arn

  filename         = "${path.module}/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  logging_config {
    log_group = var.log_group_name
    log_format = "Text"
  }

  environment {
    variables = {
      KEY_ALIAS          = aws_kms_alias.staging.name
      KEY_ARN            = aws_kms_key.staging.arn
      LOG_EVENTS         = "true"
      API_URL            = "${var.application_url}/v1"
      API_KEY_HEADER_KEY = "x-api-key"
      API_KEY_HEADER     = var.cognito_apikey_header
    }
  }
}

resource "aws_kms_key" "staging" {
  description             = "KMS key for encrypting Lambda environment variables"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "staging" {
  name          = "alias/${var.app_name}-lambda"
  target_key_id = aws_kms_key.staging.key_id
}

resource "aws_iam_role" "staging" {
  name = "lambda_execution_role_${var.app_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "staging" {
  name = "lambda_policy_${var.app_name}_staging"
  role = aws_iam_role.staging.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*",
        Effect   = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy" "cognito" {
  name = "lambda_policy_${var.app_name}-cognito"
  role = aws_iam_role.cognito.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "arn:aws:logs:*:*:*",
        Effect   = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy" "congito_kms" {
  name = "lambda_policy_${var.app_name}-cognito-kms"
  role = aws_iam_role.cognito.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
        ],
        Resource = "*",
        Effect   = "Allow"
      },
    ]
  })
}