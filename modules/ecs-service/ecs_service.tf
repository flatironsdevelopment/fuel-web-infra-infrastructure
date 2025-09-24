resource "aws_ecs_service" "backend_service" {
  name                               = "${var.app_name}"
  cluster                            = var.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.backend_task_definition.arn
  desired_count                      = var.ecs_task_desired_count
  deployment_minimum_healthy_percent = var.ecs_task_deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.ecs_task_deployment_maximum_percent
  launch_type                        = "FARGATE"
  enable_execute_command = true
  force_new_deployment = true

  dynamic "load_balancer" {
    for_each = var.connect_to_alb == true ? [1]: []

    content {
      target_group_arn = var.aws_alb_target_group_arn
      container_name   = var.app_name
      container_port   = var.container_port
    }
  }

  network_configuration {
    security_groups  = [var.ecs_container_security_group_id, var.default_security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  deployment_circuit_breaker {
    enable   = var.ecs_circuit_breaker
    rollback = var.ecs_rollback
  }

  tags = {
    Scenario = var.scenario
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}