variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`)"
}

variable "repository_names" {
  type        = list(string)
  description = "names of repositories to create"
  default     = []
}

variable "allowed_account_ids" {
  type        = list(string)
  description = "ids of AWS accounts which can pull images from the repositories."
  default     = []
}

variable "repo_lifecycle_info" {
  type        = map
  description = "expiration days for untagged images, number of images to keep and tag prefixes list for tagged ones for each repository name"
  default     = {}
}

variable "allow_push" {
  type        = bool
  description = "whether to allow pushing of images to the repository"
  default     = false
}
