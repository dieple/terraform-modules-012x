variable "enable" {
  default = false
  type    = bool
}

variable "schedule_config" {
  type    = map(string)
  default = {}
}

variable "lambda_function_arn" {
  type = string
}
