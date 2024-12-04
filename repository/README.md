# helmless/google-workload-identity-federation-terraform-module/repository

This module is a companion module to the [helmless/google-workload-identity-federation-terraform-module](../) module.
It requires the `helmless/google-workload-identity-federation-terraform-module` module to be deployed first.

By using this sub module you can easily construct the correct `principalSet` for your Github repository to use in IAM policies and bindings.

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
module "workload_identity" {
  # source = "github.com/helmless/google-workload-identity-federation-terraform-module//repository?ref=v0.2.0" # x-release-please-version
  source = "../"

  repository = "helmless/helmless"
}

resource "google_project_iam_member" "project" {
  project = data.google_project.project.project_id
  role    = "roles/run.admin"
  member  = module.workload_identity.principal_set
}

data "google_project" "project" {}
```

## Required Inputs

The following input variables are required:

### <a name="input_repository"></a> [repository](#input\_repository)

Description: The full name of the repository you want to compute the principalSet:// for. Example: helmless/helmless

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_workload_pool_name"></a> [workload\_pool\_name](#input\_workload\_pool\_name)

Description: The name of the workload identity pool to use.

Type: `string`

Default: `"github"`

### <a name="input_workload_pool_project"></a> [workload\_pool\_project](#input\_workload\_pool\_project)

Description: The project of the workload identity pool to use. Defaults to the current project.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_principal_set"></a> [principal\_set](#output\_principal\_set)

Description: The principal set id for the GitHub repository to be used in IAM policies and bindings.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.6, < 2)

- <a name="requirement_google"></a> [google](#requirement\_google) (>= 5.0)

- <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) (>= 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) (6.12.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [google-beta_google_iam_workload_identity_pool.pool](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/data-sources/google_iam_workload_identity_pool) (data source)
<!-- END_TF_DOCS -->