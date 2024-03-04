variable "admins" {
  type        = list(string)
  description = "List of principal that have the permission to manage IAM and remotate state for the project"
  default     = []
}

variable "users" {
  description = "List of principal that have the permission to manage the project"
  type        = list(string)
  default     = []
}

variable "state_bucket" {
  description = "The terraform remote state bucket. When specified, it will give permission to users to use the remote state"
  type        = string
  default     = ""
}
