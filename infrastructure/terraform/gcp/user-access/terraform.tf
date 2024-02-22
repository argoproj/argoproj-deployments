terraform {
  required_version = ">= 1.6"

  backend "gcs" {
    bucket = "7612a8-argoproj-bucket-tfstate"
    prefix = "tf/user-access"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.16"
    }
  }
}
