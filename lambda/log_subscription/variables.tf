variable "enable" {
  default = false
  type    = bool
}

variable "lambda_name" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "cloudwatch_log_subscription" {
  type = map(string)
}
