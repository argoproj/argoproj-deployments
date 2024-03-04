variable "name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "description" {
  type        = string
  description = "The description of the cluster"
  default     = ""
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  default     = "REGULAR"
}

variable "vpc" {
  type        = string
  description = "The VPC network name"
}

variable "subnet_range" {
  type        = string
  description = "Subnet CIDR"
}

variable "pod_range" {
  type        = string
  description = "Subnet secondary CIDR for pods"
}

variable "service_range" {
  type        = string
  description = "Subnet secondary CIDR for services"
}

variable "master_range" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network"
}
