# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "cb_log_group" {
  name              = var.log_group_name
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           =  var.project_name
  log_group_name = aws_cloudwatch_log_group.cb_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "targetResponseTime" {
  actions_enabled     = true
  alarm_name          = "TargetResponseTimeALB"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1

  dimensions = {
    DBInstanceIdentifier = aws_alb.alb.arn_suffix
  }

  evaluation_periods = 1
  metric_name        = "TargetResponseTime"
  namespace          = "AWS/ApplicationELB"
  period             = 300
  statistic          = "Maximum"
  threshold          = 4
}

resource "aws_cloudwatch_metric_alarm" "httpCodeTarget5XXCount" {
  actions_enabled     = true
  alarm_name          = "HTTPCode_Target_5XX_Count"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1

  dimensions = {
    DBInstanceIdentifier = aws_alb.alb.arn_suffix
  }

  evaluation_periods = 1
  metric_name        = "HTTPCode_Target_5XX_Count"
  namespace          = "AWS/ApplicationELB"
  period             = 300
  statistic          = "Maximum"
  threshold          = 1
}