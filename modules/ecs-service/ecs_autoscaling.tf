########################################################################################################################
## Define Target Tracking on ECS Cluster Task level
########################################################################################################################

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.ecs_task_max_count
  min_capacity       = var.ecs_task_min_count
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.backend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

########################################################################################################################
## Policy for CPU tracking
########################################################################################################################

resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "${var.app_name}_CPUTargetTrackingScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.cpu_target_tracking_desired_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

########################################################################################################################
## Policy for memory tracking
########################################################################################################################

resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "${var.app_name}_MemoryTargetTrackingScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.memory_target_tracking_desired_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}
