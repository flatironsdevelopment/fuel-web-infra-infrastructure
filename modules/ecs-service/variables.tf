########################################################################################################################
## Service variables
########################################################################################################################

variable "app_name" {
  description = "A Docker image-compatible name for the service"
  type        = string
}

variable "scenario" {
  description = "Scenario name for tags"
  default     = "scenario-ecs-fargate"
  type        = string
}

########################################################################################################################
## ECS variables
########################################################################################################################

variable "ecs_task_desired_count" {
  description = "How many ECS tasks should run in parallel"
  type        = number
  default = 2
}

variable "ecs_task_min_count" {
  description = "How many ECS tasks should minimally run in parallel"
  default     = 1
  type        = number
}

variable "ecs_task_max_count" {
  description = "How many ECS tasks should maximally run in parallel"
  default     = 10
  type        = number
}

# if you have multiple tasks running this should be 50%, but for 1 task
# it has to be zero so ecs can drain the task to replace it (making the service unstable for a few minutes)
variable "ecs_task_deployment_minimum_healthy_percent" {
  description = "How many percent of a service must be running to still execute a safe deployment"
  default     = 100
  type        = number
}

variable "ecs_task_deployment_maximum_percent" {
  description = "How many additional tasks are allowed to run (in percent) while a deployment is executed"
  default     = 200
  type        = number
}

variable "cpu_target_tracking_desired_value" {
  description = "Target tracking for CPU usage in %"
  default     = 70
  type        = number
}

variable "memory_target_tracking_desired_value" {
  description = "Target tracking for memory usage in %"
  default     = 80
  type        = number
}

variable "target_capacity" {
  description = "Amount of resources of container instances that should be used for task placement in %"
  default     = 100
  type        = number
}

variable "container_port" {
  description = "Port of the container"
  type        = number
  default     = 3000
}

variable "cpu_units" {
  description = "Amount of CPU units for a single ECS task"
  default     = 1024
  type        = number
}

variable "memory" {
  description = "Amount of memory in MB for a single ECS task"
  default     = 2048
  type        = number
}

variable "aws_region" {
  description = "AWS Region"
  type = string
}

variable "repository_url" {
  description = "Image URL"
  type = string
}

variable "default_security_group_id" {
  description = "VPC Security Group"
  type = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN for the task execution role"
  type = string
}

variable "ecs_task_role_arn" {
  description = "ARN for the task role"
  type = string
}

variable "ecs_log_group_name" {
  description = "Log group name for ECS"
  type = string
}

variable "ecs_cluster_id" {
  description = "ECS cluster id to attach services to"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
}

variable "aws_alb_target_group_arn" {
  description = "AWS ALB target group ARN"
  type = string
}

variable "ecs_container_security_group_id" {
  description = "ECS Container Security Group ID"
  type = string
}

variable "private_subnets" {
  description = "Private subnets for kubernetes configuration"
  default     = ""
}

variable "ecs_secret_arn" {
  description = "ARN for secrets"
  type = string
}

variable "connect_to_alb" {
  description = "Is this a public service?"
  type = bool
}

variable "secret_name" {
  description = "Name of the secret to use"
  type = string
}

variable "env_vars" {
  type    = map(string)
  default = {}
}
variable "ecs_circuit_breaker" {
  description = "Enable Circuit Breaker"
  type = bool
  default = true
}

variable "ecs_rollback" {
  description = "Automatically rollback if failure occurs"
  type = bool
  default = true
}