variable "vpc_name" {
  type        = string
  description = "The named used by the VPC"
}

variable "regions" {
  type        = set(string)
  description = "The regions that will host clusters"
  default     = []
}

variable "zones" {
  type        = set(string)
  description = "Zones under the argoproj.io domain"
  default     = []
}
