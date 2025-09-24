variable "vpc_id" {
  description = "The id of environment VPC"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
  default     = []
}

variable "app_name" {
  description = "Cognito user pool name"
  default     = ""
}
