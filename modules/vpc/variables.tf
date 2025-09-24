variable "project_name" {
  description = "A unique name for your project. This will be used as part of resource names."
  default     = ""
}

variable "cluster_name" {
  description = "Kubernetes cluster name is needed for tags"
  default     = ""
}
