locals {
  subnet_name               = "${var.name}-gke"
  subnet_pod_range_name     = "${local.subnet_name}-pods"
  subnet_service_range_name = "${local.subnet_name}-services"
}

data "google_compute_network" "vpc" {
  name = var.vpc
}

data "google_compute_router" "router" {
  name    = var.vpc
  network = data.google_compute_network.vpc.name
}

module "subnet" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "~> 9.0"

  project_id   = data.google_project.project.project_id
  network_name = data.google_compute_network.vpc.name

  subnets = [
    {
      subnet_name           = local.subnet_name
      description           = "Subnet for the GKE cluster ${var.name}"
      subnet_ip             = var.subnet_range
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]
  secondary_ranges = {
    "${local.subnet_name}" = [
      {
        range_name    = local.subnet_pod_range_name
        ip_cidr_range = var.pod_range
      },
      {
        range_name    = local.subnet_service_range_name
        ip_cidr_range = var.service_range
      }
    ]
  }
}

module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 5.0"

  project_id = data.google_project.project.project_id
  region     = var.region
  router     = data.google_compute_router.router.name
  name       = "${var.name}-gke"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetworks = [
    {
      name                     = module.subnet.subnets["${var.region}/${local.subnet_name}"].id
      source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
      secondary_ip_range_names = module.subnet.subnets["${var.region}/${local.subnet_name}"].secondary_ip_range[*].range_name
    }
  ]

}


module "cluster-dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 5.0"

  project_id = data.google_project.project.project_id
  type       = "private"
  name       = var.name
  domain     = "${var.name}.cluster."

  private_visibility_config_networks = [data.google_compute_network.vpc.self_link]

  recordsets = [
    {
      name = "ns"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = ""
      type = "NS"
      ttl  = 300
      records = [
        "ns.${var.name}.cluster.",
      ]
    },
    {
      name = "localhost"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = ""
      type = "MX"
      ttl  = 300
      records = [
        "1 localhost.",
      ]
    },
    {
      name = ""
      type = "TXT"
      ttl  = 300
      records = [
        "\"v=spf1 -all\"",
      ]
    },
  ]
}
