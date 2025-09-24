variable "app_name" {
  description = "A unique name for your project. This will be used as part of resource names."
  default     = ""
}

variable "allowed_ip_list" {
  description = "The list of IP which can get access into database"
  default     = ""
}

variable "vpc_id" {
  description = "The id of environment VPC"
  default     = ""
}

variable "subnet_ids" {
  description = "Public subnet IDs"
  default     = ""
}

variable "vpc_security_group_default" {
  description = "The id of VPC where create security group for RDS access"
  default     = ""
}

variable "db_password" {
  description = "Master database password"
  default     = ""
}

variable "db_username" {
  description = "Username for db"
  default     = ""
}

variable "db_name" {
  description = "Name of db"
  default     = ""
}
