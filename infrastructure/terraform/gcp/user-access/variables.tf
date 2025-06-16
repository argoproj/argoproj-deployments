variable "account_admins" {
  type        = list(string)
  description = "List of principal that have the permission to manage IAM, remote state, and GKE for the project"
  default     = []
}

variable "admins" {
  description = "List of principal that have the permission to manage the GKE clusters for the project"
  type        = list(string)
  default     = []
}

variable "k8s_admins" {
  description = "List of principal that have the admin permissions on Kubernetes resources"
  type        = list(string)
  default     = []
}

variable "k8s_viewers" {
  description = "List of principal that can connect and view the Kubernetes resources"
  type        = list(string)
  default     = []
}
variable "state_bucket" {
  description = "The terraform remote state bucket. When specified, it will give permission to users to use the remote state"
  type        = string
  default     = ""
}
