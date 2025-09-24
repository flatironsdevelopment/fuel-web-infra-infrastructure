
########################################################################################################################
## Service variables
########################################################################################################################

variable "ingress_ssl_arn" {
  description = "ACM ARN"
  type = string
}

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "project_name" {
  description = "A Docker image-compatible name for the service"
  type        = string
}

variable "scenario" {
  description = "Scenario name for tags"
  default     = "scenario-ecs-fargate"
  type        = string
}

########################################################################################################################
## Cloudwatch
########################################################################################################################

variable "retention_in_days" {
  description = "Retention period for Cloudwatch logs"
  default     = 7
  type        = number
}

########################################################################################################################
## ALB
########################################################################################################################

variable "healthcheck_endpoint" {
  description = "Endpoint for ALB healthcheck"
  type        = string
  default     = "/"
}

variable "healthcheck_matcher" {
  description = "HTTP status code matcher for healthcheck"
  type        = string
  default     = "200-299"
}

variable "aws_region" {
  description = "AWS Region"
  type = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets for ingress resources."
  default     = ""
}

variable "private_subnets" {
  description = "The private subnets for ingress resources."
  default     = ""
}

variable "default_security_group_id" {
  description = "VPC Security Group"
  type = string
}

variable "container_port" {
  description = "Port of the container"
  type        = number
  default     = 3000
}

variable "apps" {
  description = "An array of apps from config.json"
  type = set(object({
    app_name     = string
    domain = string
    port = number
    health_check_path = string
  }))
}

variable "log_group_name" {
  description = "CloudWatch log group name"
}
