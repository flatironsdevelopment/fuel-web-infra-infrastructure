resource "aws_cloudwatch_event_rule" "ecs_deploy_events" {
  count = local.ecs ? 1 : 0

  name          = "${var.project_name}-ecs-deploy-events"
  description   = "This rule is used to send notifications to Slack for success or failure in the deployment process"
  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail-type" : ["ECS Deployment State Change"],
    "region" : [var.aws_region],
    "detail" : {
      "clusterArn": [var.ecs_cluster_id],
      "eventName" : ["SERVICE_DEPLOYMENT_FAILED", "SERVICE_DEPLOYMENT_COMPLETED"]
    }
  })
}