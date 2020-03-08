variable "enable" {
  default = false
  type    = bool
}

variable "lambda_function_arn" {
  type = string
}

variable "sqs_config" {
  type = map(string)
}

variable "tags" {
  type = map(string)
}
