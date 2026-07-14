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

locals {
  # Delegation NS records for each child zone (apps/demo/dev), pointing the root
  # argoproj.io zone at the Cloud DNS name servers of the child zones.
  # The zone's own apex NS and SOA records are managed automatically by Cloud DNS.
  argoproj_dns_delegations = [for zone, dns in module.argoproj-dns :
    {
      name    = "${zone}.${local.argoproj_domain}"
      type    = "NS"
      ttl     = 300
      records = dns.name_servers
    }
  ]

  # Content records served directly out of the root argoproj.io zone.
  argoproj_dns_root_records = [
    {
      name    = local.argoproj_domain
      type    = "A"
      ttl     = 300
      records = ["104.198.14.52"]
    },
    {
      name    = "www.${local.argoproj_domain}"
      type    = "A"
      ttl     = 300
      records = ["104.198.14.52"]
    },
    {
      name    = "blog.${local.argoproj_domain}"
      type    = "A"
      ttl     = 300
      records = ["162.159.153.4", "162.159.152.4"]
    },
  ]

  # Content records served out of each child zone, keyed by the zone key in
  # var.zones. Zones without an entry (e.g. demo, dev) get no extra records; the
  # zone's own apex NS/SOA are managed automatically by Cloud DNS.
  zone_recordsets = {
    apps = [
      {
        name    = "cd.apps.${local.argoproj_domain}"
        type    = "A"
        ttl     = 300
        records = ["34.127.58.181"]
      },
      {
        name    = "grafana.apps.${local.argoproj_domain}"
        type    = "A"
        ttl     = 300
        records = ["34.82.184.217"]
      },
      {
        name    = "workflows.apps.${local.argoproj_domain}"
        type    = "A"
        ttl     = 300
        records = ["34.127.58.181"]
      },
    ]
  }
}

module "argoproj-dns-root" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 5.0"

  project_id = data.google_project.project.project_id
  type       = "public"
  name       = "argoproj-io"
  domain     = local.argoproj_domain

  enable_logging = false

  private_visibility_config_networks = [module.vpc.network_self_link]

  recordsets = concat(local.argoproj_dns_delegations, local.argoproj_dns_root_records)
}

module "argoproj-dns" {
  for_each = var.zones
  source   = "terraform-google-modules/cloud-dns/google"
  version  = "~> 5.0"

  project_id = data.google_project.project.project_id
  type       = "public"
  name       = replace(trimsuffix("${each.value}.${local.argoproj_domain}", "."), ".", "-")
  domain     = "${each.value}.${local.argoproj_domain}"

  force_destroy = false // Set to true to delete the zones with records

  private_visibility_config_networks = [module.vpc.network_self_link]

  recordsets = lookup(local.zone_recordsets, each.value, [])
}
