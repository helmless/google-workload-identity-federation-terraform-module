resource "google_iam_workload_identity_pool" "github" {
  display_name = var.id
  description  = "Workload Identity Pool for GitHub"

  workload_identity_pool_id = var.id
}

resource "google_iam_workload_identity_pool_provider" "github" {
  display_name = var.id
  description  = "Workload Identity Provider for GitHub in ${var.github_organization}"

  workload_identity_pool_id          = google_iam_workload_identity_pool.github.id
  workload_identity_pool_provider_id = "${var.id}-oidc"

  attribute_condition = "attribute.repository_owner == \"${var.github_organization}\""
  attribute_mapping = {
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.job_workflow_ref" = "assertion.job_workflow_ref"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "google.subject"             = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
