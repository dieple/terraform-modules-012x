variable "enable" {
  default = false
  type    = bool
}

variable "region" {
  type = string
}

variable "lambda_function_arn" {
  type = string
}
