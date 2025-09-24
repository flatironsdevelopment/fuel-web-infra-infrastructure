########################################################################################################################
## Creates ECS Task Definition
########################################################################################################################

locals {
   secretKeys = keys(var.env_vars)
}

locals {
  secrets_list = [
    for name in local.secretKeys : {
      name  = name
      valueFrom = "${var.ecs_secret_arn}:${name}::"
    }
  ]
}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  cpu                      = var.cpu_units
  memory                   = var.memory

  container_definitions = jsonencode([
    {
      name         = var.app_name
      image        = var.repository_url
      cpu          = var.cpu_units
      memory       = var.memory
      essential    = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      secrets = local.secrets_list
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = var.ecs_log_group_name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "${var.app_name}-log-stream"
        }
      }
    }
  ])

  tags = {
    Scenario = var.scenario
  }
}
