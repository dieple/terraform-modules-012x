variable "name" {
  type        = string
  description = "Name (e.g. `app` or `chamber`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "principals" {
  type        = map(list(string))
  description = "Map of service name as key and a list of ARNs to allow assuming the role as value. (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`)))"
  default     = {}
}

variable "policy_documents" {
  type        = list(string)
  description = "List of JSON IAM policy documents"
  default     = []
}

variable "policy_document_count" {
  description = "Number of policy documents (length of policy_documents list)."
  default     = 1
}

variable "max_session_duration" {
  default     = 3600
  description = "The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours"
}

variable "enabled" {
  description = "Set to `false` to prevent the module from creating any resources"
  default     = true
}

variable "role_description" {
  type        = string
  description = "The description of the IAM role that is visible in the IAM role manager"
}

variable "policy_description" {
  type        = string
  description = "The description of the IAM policy that is visible in the IAM policy manager"
}

variable "additional_policy_arns" {
  description = "Optional additional attached IAM policy ARNs."
  type        = list(string)
  default     = []
}

variable "create_ec2_profile" {
  default = false
}

variable "path" {
  description = "If provided, all IAM roles will be created on this path."
  default     = "/"
}
