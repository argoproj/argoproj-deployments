variable "vpc_name" {
  type        = string
  description = "The named used by the VPC"
}

variable "regions" {
  type        = set(string)
  description = "The regions that will host clusters"
  default     = []
}
