provider "google" {
  project = "argo-demo-apps"
  region  = "us-central1"

  default_labels = {
    "managed-by"  = "terraform"
    "github-org"  = "argoproj"
    "github-repo" = "argoproj-deployments"
    "module"      = "gke"
  }
}
