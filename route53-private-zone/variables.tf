variable "zone_name" {
  type        = string
  description = "Name of the hosted zone"
}

variable "main_vpc" {
  type        = string
  description = "Main VPC ID that will be associated with this hosted zone"
}

variable "parent_zone_name" {
  type        = string
  description = "The parent zone name that should have NS records from the main zone_name added to it"
}

variable "secondary_vpcs" {
  type        = list
  default     = []
  description = "List of VPCs that will also be associated with this zone"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to destroy all records inside if the hosted zone is deleted"
}

variable "tags" {
  type    = map(string)
  default = {}
}
