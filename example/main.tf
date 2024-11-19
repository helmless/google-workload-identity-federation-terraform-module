module "github_federation" {
  source              = "ssh://git@github.com:helmless/google-workload-identity-federation-terraform-module.git?ref=v0.1.0" # x-release-please-version
  github_organization = "helmless"
}

// With the workload identity pool created, you have two options for authenticating with Google Cloud.
// 1. Use Direct Workload Identity Federation to authenticate with Google Cloud.
// 2. Use a service account to authenticate with Google Cloud.

// Option 1: Direct Workload Identity Federation

module "cloudrun" {
  source = "ssh://git@github.com:helmless/google-cloudrun-terraform-module.git"
  name   = "example-service"
}

resource "google_cloud_run_v2_service_iam_binding" "example_service" {
  name = module.cloudrun.name

  role = "roles/run.admin"
  members = [
    "${module.github_federation.repository_principal_set_id_prefix}/example-repository",
  ]
}

// Option 2: Use a dedicated service account to authenticate with Google Cloud

resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "GitHub Actions"
  description  = "Service account for GitHub Actions to authenticate with Google Cloud"
}

resource "google_service_account_iam_member" "github_actions_workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = module.github_federation.organization_principal_set_id
}

resource "google_cloud_run_v2_service_iam_binding" "example_service" {
  name = module.cloudrun.name

  role = "roles/run.admin"
  members = [
    google_service_account.github_actions.email
  ]
}
