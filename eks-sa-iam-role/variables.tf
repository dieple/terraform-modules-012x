variable "oidc_provider" {}
variable "name" {}
variable "cluster_name" {}
variable "sa_ns" {}
variable "sa_iam_policy_json" {}
variable "tags" {}
variable "enabled" {
  type        = bool
  default     = false
}