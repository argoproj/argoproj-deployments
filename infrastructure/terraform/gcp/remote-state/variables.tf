variable "bucket_name" {
  type        = string
  description = "A name that will be used to create the full bucket name"
}

variable "location" {
  description = "The location of the bucket"
  type        = string
  default     = "us"
}
