data "google_client_config" "default" {}

data "google_project" "project" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  version = "~> 30.0"

  project_id  = data.google_project.project.project_id
  name        = var.name
  description = var.description

  kubernetes_version = var.kubernetes_version
  release_channel    = var.release_channel

  // Network
  region            = var.region
  network           = var.vpc
  subnetwork        = local.subnet_name
  ip_range_pods     = local.subnet_pod_range_name
  ip_range_services = local.subnet_service_range_name

  // General
  initial_node_count       = 3
  datapath_provider        = "ADVANCED_DATAPATH"
  network_policy           = false
  remove_default_node_pool = true
  create_service_account   = true
  issue_client_certificate = false


  // Security
  master_ipv4_cidr_block        = var.master_range
  enable_private_endpoint       = false // Not realy clear, but set this to true to disable the public endpoint
  deploy_using_private_endpoint = true
  enable_private_nodes          = true
  master_global_access_enabled  = false

  // Set to false if you need to delete/recreate the cluster
  deletion_protection = true

  depends_on = [module.subnet]

}
