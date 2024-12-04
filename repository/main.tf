data "google_iam_workload_identity_pool" "pool" {
  provider                  = google-beta
  workload_identity_pool_id = var.workload_pool_name
  project                   = var.workload_pool_project
}