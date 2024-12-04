output "principal_set" {
  description = "The principal set id for the GitHub repository to be used in IAM policies and bindings."
  value       = "principalSet://iam.googleapis.com/${data.google_iam_workload_identity_pool.pool.name}/attribute.repository/${var.repository}"
}
