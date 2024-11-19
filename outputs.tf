output "pool_name" {
  value       = google_iam_workload_identity_pool.github.name
  description = "The name of the workload identity pool. Example: projects/1234567890/locations/global/workloadIdentityPools/github"
}

output "provider_name" {
  value       = google_iam_workload_identity_pool_provider.github.name
  description = "The name of the workload identity provider."
}

output "organization_principal_set_id" {
  description = "The principal set id for the GitHub organization to be used in IAM policies and bindings. Warning: this will grant all repositories in your Github organization the IAM role you bind this to. Use the repository_principal_set_id for more granular control."
  value       = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository_owner/${var.github_organization}"
}

output "repository_principal_set_id_prefix" {
  description = "The principal set id for the GitHub repository to be used in IAM policies and bindings. You must append the repository name to this id to use it."
  value       = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_organization}"
}
