variable "name" {
  type        = "string"
  description = "Application or solution name (e.g. `app`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "s3_actions" {
  type        = "list"
  default     = ["s3:GetObject"]
  description = "Actions to allow in the policy"
}

variable "s3_resources" {
  type        = "list"
  description = "S3 resources to apply the actions specified in the policy"
}

variable "force_destroy" {
  default     = "false"
  description = "Destroy even if it has non-Terraform-managed IAM access keys, login profiles or MFA devices"
}

variable "path" {
  default     = "/"
  description = "Path in which to create the user"
}

variable "enabled" {
  default     = "true"
  description = "Set to false to prevent the module from creating any resources"
}

variable "pgp_key" {
  default = "dummy"
}
