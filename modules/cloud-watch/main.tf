locals {
  ecs  = !var.kubernetes
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "high-cpu-utilization-${var.project_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors RDS CPU utilization"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alarm_topic.arn]
  dimensions = {
    DBInstanceIdentifier = "${var.project_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_free_storage_space" {
  alarm_name          = "low-free-storage-space-${var.project_name}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10000000000"
  alarm_description   = "This metric monitors RDS free storage space"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alarm_topic.arn]
  dimensions = {
    DBInstanceIdentifier = "${var.project_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_freeable_memory" {
  alarm_name          = "low-freeable-memory-${var.project_name}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = 209715200
  alarm_description   = "This metric monitors RDS freeable memory"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alarm_topic.arn]
  dimensions = {
    DBInstanceIdentifier = "${var.project_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_database_connections" {
  alarm_name          = "high-database-connections-${var.project_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric monitors RDS database connections"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alarm_topic.arn]
  dimensions = {
    DBInstanceIdentifier = "${var.project_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "freespace" {
  for_each = { for app in var.apps : app.app_name => app if app.postgres }
  
  actions_enabled     = true
  alarm_name          = "FreeStorageSpace - ${each.value.app_name} - DB"
  comparison_operator = "LessThanOrEqualToThreshold"
  datapoints_to_alarm = 1

  dimensions = {
    DBInstanceIdentifier = each.value.app_name
  }

  evaluation_periods = 1
  metric_name        = "FreeStorageSpace"
  namespace          = "AWS/RDS"
  period             = 300
  statistic          = "Average"
  threshold          = 30 * 0.1 * pow(1024, 3)
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "high-cpu" {
  for_each = { for app in var.apps : app.app_name => app if app.postgres }
  
  actions_enabled     = "true"
  alarm_name          = "High CPU Usage - ${each.value.app_name} -db"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "1"

  dimensions = {
    DBInstanceIdentifier = each.value.app_name
  }

  evaluation_periods = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/RDS"
  period             = "300"
  statistic          = "Average"
  threshold          = "90"
  treat_missing_data = "missing"
}


resource "aws_cloudwatch_metric_alarm" "freeable_memory" {
  for_each = { for app in var.apps : app.app_name => app if app.postgres }
  
  actions_enabled     = true
  alarm_description   = "500Mb available for use"
  alarm_name          = "High Memory Usage - ${each.value.app_name} - DB"
  comparison_operator = "LessThanOrEqualToThreshold"
  datapoints_to_alarm = 1

  dimensions = {
    DBInstanceIdentifier = each.value.app_name
  }

  evaluation_periods = 1
  metric_name        = "FreeableMemory"
  namespace          = "AWS/RDS"
  period             = 60
  statistic          = "Maximum"
  threshold          = 500000000
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "readiops" {
  for_each = { for app in var.apps : app.app_name => app if app.postgres }

  actions_enabled     = true
  alarm_name          = "ReadIOPS - ${each.value.app_name} - DB"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1

  dimensions = {
    DBInstanceIdentifier = each.value.app_name
  }

  evaluation_periods = 1
  metric_name        = "ReadIOPS"
  namespace          = "AWS/RDS"
  period             = 300
  statistic          = "Maximum"
  threshold          = 1000
  treat_missing_data = "missing"
}


