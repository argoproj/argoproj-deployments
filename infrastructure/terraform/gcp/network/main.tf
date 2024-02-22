data "google_project" "project" {}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = data.google_project.project.project_id
  network_name = var.vpc_name
  subnets      = []

  routing_mode = "REGIONAL"
}

resource "google_compute_firewall" "rules" {
  project = data.google_project.project.project_id
  name    = "allow-ssh"
  network = module.vpc.network_name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

module "cloud_router" {
  for_each = var.regions

  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  name    = var.vpc_name
  project = data.google_project.project.project_id
  network = module.vpc.network_name
  region  = each.value
}
