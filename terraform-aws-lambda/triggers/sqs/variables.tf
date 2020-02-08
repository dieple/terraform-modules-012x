variable "enable" {
  default = 0
}

variable "lambda_function_arn" {}

variable "sqs_config" {
  type = "map"
}

variable "tags" {
  type = "map"
}
