########################################################################################################################
## IAM Role for ECS Task execution
########################################################################################################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}_ECS_TaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
  

  tags = {
    Scenario = var.scenario
  }
}

data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_secrets_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

########################################################################################################################
## IAM Role for ECS Task
########################################################################################################################

# Create an IAM policy
resource "aws_iam_policy" "ecs_task_policy" {
  name = "${var.project_name}-ecs-task-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecs:ExecuteCommand",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  })

  tags = {
    Scenario = var.scenario
  }
}

resource "aws_iam_role" "task_exec_role" {
  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "iam_role_policy_attachment" {
  name = "Policy Attachement"
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  roles      = [aws_iam_role.task_exec_role.name]
}
