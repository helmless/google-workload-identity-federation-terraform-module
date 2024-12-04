variable "repository" {
  description = "The full name of the repository you want to compute the principalSet:// for. Example: helmless/helmless"
  type        = string
}

variable "workload_pool_project" {
  description = "The project of the workload identity pool to use. Defaults to the current project."
  type        = string
  default     = null
}

variable "workload_pool_name" {
  description = "The name of the workload identity pool to use."
  type        = string
  default     = "github"
}