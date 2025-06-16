# https://cloud.google.com/iam/docs/permissions-reference

locals {
  admin_roles = [
    // Roles used to read IAM and remote-state
    "roles/iam.roleViewer",
    "roles/storage.objectUser",

    // Roles to create all other modules except IAM and remote-state
    "roles/compute.networkAdmin",       // Create VPC
    "roles/iam.serviceAccountAdmin",    // Create Cluster
    "roles/iam.serviceAccountUser",     // Create Cluster
    "roles/container.admin",            // Create Cluster
    "roles/iap.tunnelResourceAccessor", // SSH to nodes
    "roles/compute.admin",              // SSH to nodes
    "roles/dns.admin"                   // Create cluster DNS zone
  ]

  iam_elevated_roles = [
    "roles/iam.roleAdmin",
    "roles/resourcemanager.projectIamAdmin"
  ]

  bucket_roles = [
    "roles/storage.admin",
    "roles/cloudkms.admin",
  ]
}

data "google_project" "project" {}

module "custom-roles-account-admin" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 8.1.0"

  target_level = "project"
  target_id    = data.google_project.project.project_id
  role_id      = "terraformDeployerAdmin"
  title        = "Terraform Deployer Admin"
  description  = "Role used to deploy all terraform modules and gain cluster admin access"
  base_roles   = concat(local.iam_elevated_roles, local.bucket_roles)
  excluded_permissions = [
    // No permission to delete the state-bucket
    "storage.buckets.delete",
    // organization role not available in project
    "cloudkms.autokeyConfigs.get", "cloudkms.autokeyConfigs.update",
    "resourcemanager.projects.list", "resourcemanager.projects.get"
  ]
  members = var.account_admins
}

module "custom-roles-admin" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 8.1.0"

  target_level = "project"
  target_id    = data.google_project.project.project_id
  role_id      = "terraformDeployer"
  title        = "Terraform Deployer"
  description  = "Role used to deploy terraform GKE module and gain cluster admin access"
  base_roles   = local.admin_roles
  excluded_permissions = [
    // organization role not available in project
    "resourcemanager.projects.list", "resourcemanager.projects.get",
    "compute.firewallPolicies.copyRules", "compute.firewallPolicies.move",
    "networksecurity.firewallEndpoints.create", "networksecurity.firewallEndpoints.delete",
    "networksecurity.firewallEndpoints.get", "networksecurity.firewallEndpoints.list",
    "networksecurity.firewallEndpoints.update", "networksecurity.firewallEndpoints.use",
    "compute.oslogin.updateExternalUser",
    "compute.securityPolicies.addAssociation", "compute.securityPolicies.removeAssociation",
    "compute.securityPolicies.copyRules", "compute.securityPolicies.move"
  ]
  members = distinct(concat(var.admins, var.account_admins))
}

module "custom-roles-k8s-admin" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 8.1.0"

  target_level         = "project"
  target_id            = data.google_project.project.project_id
  role_id              = "k8sClusterAdmin"
  title                = "Kubernetes Cluster Admin"
  description          = "Role used to connect to GKE clusters and have cluster admin access"
  base_roles           = ["roles/container.admin"]
  excluded_permissions = ["resourcemanager.projects.list", "resourcemanager.projects.get"] // organization role not available in project
  members              = var.k8s_admins
}

module "custom-roles-k8s-viewer" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 8.1.0"

  target_level         = "project"
  target_id            = data.google_project.project.project_id
  role_id              = "k8sClusterViewer"
  title                = "Kubernetes Cluster Viewer"
  description          = "Role used to connect to GKE clusters and have read-only on the resources"
  base_roles           = ["roles/container.viewer"]
  excluded_permissions = ["resourcemanager.projects.list", "resourcemanager.projects.get"] // organization role not available in project
  members              = var.k8s_viewers
}

resource "google_project_iam_member" "admin_project_viewer" {
  for_each = toset(concat(var.admins, var.account_admins))
  project  = data.google_project.project.project_id
  role     = "roles/viewer"
  member   = each.key
}
