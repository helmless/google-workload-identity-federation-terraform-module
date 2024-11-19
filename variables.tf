variable "id" {
  description = "The id of the workload identity pool and provider"
  type        = string
  default     = "github"
}

variable "github_organization" {
  description = "The GitHub organization to bind to the workload identity pool and provider"
  type        = string
}


