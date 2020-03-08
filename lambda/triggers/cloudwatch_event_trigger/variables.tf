variable "enable" {
  default = false
  type    = bool
}

variable "event_config" {
  default = {}
  type    = map(string)
}

variable "lambda_function_arn" {
  type = string
}
