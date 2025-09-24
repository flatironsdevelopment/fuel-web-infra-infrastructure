variable "app_name" {
  description = "Cognito user pool name"
  default     = ""
}

variable "application_url" {
  description = "Cognito application name"
  default     = ""
}

variable "cognito_apikey_header" {
  description = "Cognito api key header"
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  default     = ""
}

variable "log_group_name" {
  description = "CloudWatch log group"
}

