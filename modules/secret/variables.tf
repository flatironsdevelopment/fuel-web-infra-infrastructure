variable "name" {
  description = "Secret Name"
}

variable "env_vars" {
  type    = map(string)
  default = {}
}