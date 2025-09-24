resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role_${var.project_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Effect = "Allow",
      },
    ],
  })
}

resource "aws_lambda_function" "sns_to_slack" {
  function_name = "snsToSlack-${var.project_name}"
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_execution_role.arn

  filename         = "${path.module}/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_slack.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.rds_alarm_topic.arn
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.rds_alarm_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_to_slack.arn
}


resource "aws_lambda_function" "sns_deploy_to_slack" {
  count = local.ecs ? 1 : 0

  function_name = "snsDeployInfoToSlack-${var.project_name}"
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  role             = aws_iam_role.lambda_execution_role.arn

  filename         = "${path.module}/lambda_function_deploy.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_function_deploy.zip")

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }

}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  count = local.ecs ? 1 : 0

  rule      = aws_cloudwatch_event_rule.ecs_deploy_events[0].name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.sns_deploy_to_slack[0].arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  count = local.ecs ? 1 : 0

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_deploy_to_slack[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_deploy_events[0].arn
}