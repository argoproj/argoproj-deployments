locals {
  argoproj_domain = "argoproj.io."
}

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

# module "argoproj-dns-root" {
#   source  = "terraform-google-modules/cloud-dns/google"
#   version = "~> 5.0"

#   project_id = data.google_project.project.project_id
#   type       = "public"
#   name       = "argoproj-io"
#   domain     = local.argoproj_domain

#   enable_logging = true

#   private_visibility_config_networks = [module.vpc.network_self_link]

#   recordsets = [for key, dns in module.argoproj-dns :
#     {
#       name    = key
#       records = dns.name_servers
#       ttl     = 300
#       type    = "NS"
#     }
#   ]
# }

module "argoproj-dns" {
  for_each = var.zones
  source   = "terraform-google-modules/cloud-dns/google"
  version  = "~> 5.0"

  project_id = data.google_project.project.project_id
  type       = "public"
  name       = replace(trimsuffix("${each.value}.${local.argoproj_domain}", "."), ".", "-")
  domain     = "${each.value}.${local.argoproj_domain}"

  enable_logging = true

  force_destroy = false // Set to true to delete the zones with records

  private_visibility_config_networks = [module.vpc.network_self_link]
}
