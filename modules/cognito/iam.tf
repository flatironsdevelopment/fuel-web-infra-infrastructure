resource "aws_iam_role" "sns_role" {
  name = "${var.app_name}-sns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        }
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_policy" "sns_sms_policy" {
  name        = "${var.app_name}-sns-sms-policy"
  path        = "/"
  description = "Policy for Cognito to send SMS through SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sns:Publish",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sns_publish_attachment" {
  role       = aws_iam_role.sns_role.name
  policy_arn = aws_iam_policy.sns_sms_policy.arn
}
