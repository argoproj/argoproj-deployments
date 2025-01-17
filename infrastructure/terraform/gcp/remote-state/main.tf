locals {
  bucket_name = "${random_id.bucket_prefix.hex}-${var.bucket_name}-bucket-tfstate"
}

data "google_project" "project" {
}

resource "google_project_iam_member" "default" {
  project = data.google_project.project.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
}

resource "random_id" "bucket_prefix" {
  byte_length = 3
}

resource "google_storage_bucket" "state" {
  name                     = "${random_id.bucket_prefix.hex}-${var.bucket_name}-bucket-tfstate"
  force_destroy            = false
  location                 = upper(var.location)
  storage_class            = "STANDARD"
  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.state_bucket.id
  }

  depends_on = [
    google_project_iam_member.default
  ]
}

resource "google_kms_key_ring" "state" {
  name     = local.bucket_name
  location = lower(var.location)
}

resource "google_kms_crypto_key" "state_bucket" {
  name            = "tf-state-bucket"
  key_ring        = google_kms_key_ring.state.id
  rotation_period = "86400s"

  lifecycle {
    prevent_destroy = false
  }
}
