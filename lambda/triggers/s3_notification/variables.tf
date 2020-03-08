variable "enable" {
  default = false
  type    = bool
}

variable "lambda_function_arn" {
  type = string
}

variable "bucket" {
  type = string
}

variable "events" {
  type = string
}

variable "principal" {
  type = string
}
variable "source_arn" {
  type = string
}
