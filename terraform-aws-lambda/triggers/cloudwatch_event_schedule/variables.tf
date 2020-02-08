variable "enable" {
  default = 0
}

variable "schedule_config" {
  default = {}
  type    = "map"
}

variable "lambda_function_arn" {}
