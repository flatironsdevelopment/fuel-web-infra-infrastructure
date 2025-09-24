output "alb_dns" {
    description = "The CNAME for the ALB"
    value = aws_alb.alb.dns_name
}

output "ecs_log_group_name" {
    description = "The name of the cloudwatch log group for ECS"
    value = aws_cloudwatch_log_group.cb_log_group.name
}

output "ecs_task_execution_role_arn" {
    description = "The ARN of the IAM execution role"
    value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
    description = "The ARN of the IAM rask role"
    value = aws_iam_role.task_exec_role.arn
}

output "ecs_cluster_id" {
    description = "The ARN of the IAM execution role"
    value = aws_ecs_cluster.default.id
}

output "ecs_container_security_group_id" {
    description = "ECS Container Security Group ID"
    value = aws_security_group.ecs_container_instance.id
}

output "ecs_cluster_name" {
    description = "The name of the cluster"
    value = aws_ecs_cluster.default.name
}

output "ecs_secret_arn" {
    description = "ARN of the secrets for the app"
    value = aws_secretsmanager_secret.secret.arn
}

output "aws_alb_target_groups" {
    description = "ALB target groups"
    value = aws_alb_target_group.app_service_target_group
}
