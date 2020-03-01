variable "name" {
  type = string
}

variable "environment" {
  type        = string
  description = "Enviornment (e.g. `prod`, `dev`, `staging`)"
}

variable "zone_name" {
  type        = string
  default     = "$${name}.$${environment}.$${parent_zone_name}"
  description = "Zone name"
}

variable "parent_zone_id" {
  type        = string
  default     = ""
  description = "ID of the hosted zone to contain this record  (or specify `parent_zone_name`)"
}

variable "parent_zone_name" {
  type        = string
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit','XYZ')"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating or accessing any resources"
}
