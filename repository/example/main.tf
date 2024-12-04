module "workload_identity" {
  # source = "github.com/helmless/google-workload-identity-federation-terraform-module//repository?ref=v0.1.0" # x-release-please-version
  source = "../"

  repository = "helmless/helmless"
}

resource "google_project_iam_member" "project" {
  project = data.google_project.project.project_id
  role    = "roles/run.admin"
  member  = module.workload_identity.principal_set
}

data "google_project" "project" {}