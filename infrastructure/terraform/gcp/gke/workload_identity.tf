module "external-dns-identity" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "~> 30.0"

  project_id          = data.google_project.project.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  cluster_name        = var.name
  location            = var.region
  name                = "external-dns"
  namespace           = "external-dns"
  roles               = ["roles/dns.admin"]
}
