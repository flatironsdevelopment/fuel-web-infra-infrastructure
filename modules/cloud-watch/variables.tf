variable "project_name" {
  description = "Repository name will be created based on project name"
  default     = ""
}

variable "slack_webhook_url" {
  description = "The Slack webhook URL for sending notifications"
  type        = string
  default     = "https://hooks.slack.com/services/YOUR_WORKSPACE_ID/YOUR_CHANNEL_ID/YOUR_WEBHOOK_TOKEN"
}

variable "kubernetes" {
  description = "Using k8s?"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "Aws Region"
  type        = string
}

variable "ecs_cluster_id" {
  description = "cluster Arn"
  default     = ""
}

variable "apps" {
  description = "An array of apps from config.json"
  type = set(object({
    app_name     = string
    technology = string
    dockerfile = optional(string)
    build_env = optional(string)
    postgres = optional(string)
  }))
}