variable "zone_name" {}

variable "records" {
  type = list(string)
}

variable "ttl_default" {
  type    = number
  default = 300
}

variable "tags" {
  type = map(string)
}
