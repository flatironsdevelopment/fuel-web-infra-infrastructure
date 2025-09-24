variable "github_token" {
  description = "Github personal access token"
}

variable "github_repo_name" {
  description = "Github repo name"
  default     = ""
}

variable "project_name" {
  description = "The name of the project"
}

variable "aws_access_key_id" {
  description = "AWS access key needed for ECR access"
}

variable "aws_secret_access_key" {
  description = "AWS secret key needed for ECR access"
}

variable "aws_region" {
  description = "AWS region"
}

variable "github_organization" {
  description = "Github organization where repositories should be created"
}

variable "kubernetes" {
  description = "Using k8s?"
}

variable "github_infrastructure_full_name" {
  description = "Full name of infrastructure repo"
  default = ""
}

variable "apps" {
  description = "An array of apps from config.json"
  type = set(object({
    app_name     = string
    technology = string
    dockerfile = string
    build_env = string
    branch = string
  }))
}

variable "workers" {
  description = "An array of workers from config.json"
  type = set(object({
    app_name     = string
    technology = string
    dockerfile = string
    worker_name = string
    build_env = string
    branch = string
  }))
}
