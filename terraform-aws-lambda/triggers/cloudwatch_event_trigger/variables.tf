variable "enable" {
  default = 0
}

variable "event_config" {
  default = {}
  type    = "map"
}

variable "lambda_function_arn" {}
