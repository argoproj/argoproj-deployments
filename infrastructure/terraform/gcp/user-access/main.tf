# https://cloud.google.com/iam/docs/permissions-reference

locals {
  users = distinct(concat(var.admins, var.users))
  user_roles = [
    "iam.roleViewer",
    "container.viewer",
  ]
  admin_roles = [
    "viewer",
    "cloudkms.admin",
    "compute.networkAdmin",
    "iam.serviceAccountAdmin",
    "iam.serviceAccountUser",
    "container.admin",
    "iap.tunnelResourceAccessor",
    "compute.admin",
  ]
}

data "google_project" "project" {}

# This group should be given to terraform deployer with elevated permissions because it allows to give
resource "google_project_iam_custom_role" "terraform-deployer-iam" {
  role_id     = "terraformDeployerIAM"
  title       = "Terraform Deployer IAM"
  description = "Role used to deploy terraform IAM resources"
  permissions = [
    // roles/iam.roleAdmin
    "iam.roles.create",
    "iam.roles.delete",
    "iam.roles.get",
    "iam.roles.list",
    "iam.roles.undelete",
    "iam.roles.update",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",

    // roles/resourcemanager.projectIamAdmin
    "resourcemanager.projects.setIamPolicy",

    // Allow to create s3 bucket (everything but delete)
    "storage.buckets.create",
    "storage.buckets.createTagBinding",
    "storage.buckets.deleteTagBinding",
    "storage.buckets.enableObjectRetention",
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
    "storage.buckets.getObjectInsights",
    "storage.buckets.list",
    "storage.buckets.listEffectiveTags",
    "storage.buckets.listTagBindings",
    "storage.buckets.setIamPolicy",
    "storage.buckets.update",
  ]
}

resource "google_project_iam_custom_role" "terraform-deployer" {
  role_id     = "terraformDeployer"
  title       = "Terraform Deployer"
  description = "Role used to deploy terraform locally"
  permissions = [
    // roles/iam.roleViewer
    "iam.roles.list",
    "iam.roles.get",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",

    // Create GKE modules

  ]
}

resource "google_project_iam_binding" "terraform-deployer-iam" {
  project = data.google_project.project.project_id
  role    = google_project_iam_custom_role.terraform-deployer-iam.name

  members = var.admins
}

resource "google_project_iam_binding" "terraform-deployer" {
  project = data.google_project.project.project_id
  role    = google_project_iam_custom_role.terraform-deployer.name

  members = local.users
}

resource "google_project_iam_binding" "users" {
  for_each = toset(local.user_roles)

  project = data.google_project.project.project_id
  role    = "roles/${each.key}"
  members = local.users
}

resource "google_project_iam_binding" "admins" {
  for_each = toset(local.admin_roles)

  project = data.google_project.project.project_id
  role    = "roles/${each.key}"
  members = var.admins
}

resource "google_storage_bucket_iam_binding" "binding" {
  count = var.state_bucket != "" ? 1 : 0

  bucket  = var.state_bucket
  role    = "roles/storage.objectUser"
  members = local.users
}
