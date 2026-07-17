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
  argoproj_domain = "argoproj.io."

  # Delegation NS records for each child zone (apps/demo/dev), pointing the root
  # argoproj.io zone at the Cloud DNS name servers of the child zones.
  # The zone's own apex NS and SOA records are managed automatically by Cloud DNS.
  # `name` is the label relative to the zone domain; the cloud-dns module appends
  # the domain (var.domain) to it.
  argoproj_dns_delegations = [for zone, dns in module.argoproj-dns :
    {
      name    = zone
      type    = "NS"
      ttl     = 300
      records = dns.name_servers
    }
  ]

  # Content records served directly out of the root argoproj.io zone.
  # `name` is relative to the zone domain ("" = apex); the module appends the domain.
  argoproj_dns_root_records = [
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = ["104.198.14.52"]
    },
    {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = ["104.198.14.52"]
    },
    {
      name    = "blog"
      type    = "A"
      ttl     = 300
      records = ["162.159.153.4", "162.159.152.4"]
    },
    # Google domain-ownership verification (moved from the old alex-sb apex zone).
    # Must remain as long as Google ownership of argoproj.io is required.
    {
      name    = ""
      type    = "TXT"
      ttl     = 300
      records = ["google-site-verification=ENitAVgKBcpwjqDbs-HPY88Wo69jDxzcyuiDKOgVX58"]
    },
    # Bluesky (bsky.app) domain-handle verification, letting us claim and verify
    # the @argoproj.io handle on the AT Protocol network. The DID value maps the
    # handle to our account; must remain for the handle to stay verified.
    {
      name    = "_atproto"
      type    = "TXT"
      ttl     = 300
      records = ["did=did:plc:vfsdpszrz7vp2u2k7vwto4g7"]
    },
  ]
}

module "argoproj-dns-root" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 5.0"

  project_id = data.google_project.project.project_id
  type       = "public"
  name       = replace(trimsuffix(local.argoproj_domain, "."), ".", "-")
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

  # No recordsets here: records inside apps.argoproj.io are managed by
  # external-dns (policy: sync) running in the cluster. See external-dns/values.yaml.
}
