variable "project_name" {
  description = "Repository name will be created based on project name"
  default     = ""
}

variable "apps" {
  description = "An array of apps from config.json"
  type = set(object({
    app_name     = string
    technology = string
    dockerfile = string
    build_env = string
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
  }))
}