resource "aws_sns_topic" "rds_alarm_topic" {
  name = "rds-alarm-topic-${var.project_name}"
}