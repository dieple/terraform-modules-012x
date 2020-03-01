variable "force_destroy" {
  description = "Destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices."
  type        = bool
  default     = false
}

variable "path" {
  description = "Path in which to create the user"
  default     = "/"
  type        = string
}

variable "pgp_key" {
  description = "map of users pgp public keys. YOU MUST PROVIDE ONE!"
}

variable "user_id" {}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "policy" {
  //  type        = "map"
  description = "List of JSON IAM policy documents"
  default     = ""
  type        = string
}

variable "enabled" {
  default = false
  type    = bool
}
