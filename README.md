# helmless/google-workload-identity-federation-terraform-module

A [Terraform][terraform] module to create and manage a
Google Workload Identity Federation Pool in [Google Cloud][goolge-cloud].

The pool allows Github Actions to authenticate with Google Cloud and to deploy to Google Cloud Run.

[goolge-cloud]: https://cloud.google.com
[terraform]: https://www.terraform.io

# asdf tools

This repository has a _.tools-versions_ file used by [asdf](https://asdf-vm.com/) to install the necessary tools. For this you need the following additional plugins:

```
asdf plugin add terraform-docs https://github.com/looztra/asdf-terraform-docs
asdf plugin add tflint https://github.com/skyzyx/asdf-tflint
asdf install
```

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
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
```

## Required Inputs

The following input variables are required:

### <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization)

Description: The GitHub organization to bind to the workload identity pool and provider

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_id"></a> [id](#input\_id)

Description: The id of the workload identity pool and provider

Type: `string`

Default: `"github"`

## Outputs

The following outputs are exported:

### <a name="output_organization_principal_set_id"></a> [organization\_principal\_set\_id](#output\_organization\_principal\_set\_id)

Description: The principal set id for the GitHub organization to be used in IAM policies and bindings. Warning: this will grant all repositories in your Github organization the IAM role you bind this to. Use the repository\_principal\_set\_id for more granular control.

### <a name="output_pool_id"></a> [pool\_id](#output\_pool\_id)

Description: The id of the workload identity pool. Example: projects/1234567890/locations/global/workloadIdentityPools/github

### <a name="output_provider_id"></a> [provider\_id](#output\_provider\_id)

Description: The id of the workload identity provider.

### <a name="output_repository_principal_set_id_prefix"></a> [repository\_principal\_set\_id\_prefix](#output\_repository\_principal\_set\_id\_prefix)

Description: The principal set id for the GitHub repository to be used in IAM policies and bindings. You must append the repository name to this id to use it.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.6, < 2)

- <a name="requirement_google"></a> [google](#requirement\_google) (>= 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_google"></a> [google](#provider\_google) (6.12.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [google_iam_workload_identity_pool.github](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) (resource)
- [google_iam_workload_identity_pool_provider.github](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) (resource)
<!-- END_TF_DOCS -->
