variable "file_name" {
  type        = string
  description = "lambda function filename name"
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = null
}

variable "function_name" {
  type        = string
  description = "lambda function name"
}

variable "handler" {
  type        = string
  description = "lambda function handler"
}

variable "role_arn" {
  type        = string
  description = "lambda function role arn"
}

variable "description" {
  description = "lambda function description"
  default     = "Managed by Terraform"
  type        = string
}

variable "memory_size" {
  description = "lambda function memory size"
  default     = 128
  type        = number
}

variable "runtime" {
  description = "lambda function runtime"
  default     = "nodejs10.x"
  type        = string
}

variable "timeout" {
  description = "lambda function runtime"
  default     = 300
  type        = number
}

variable "publish" {
  description = "Publish lambda function"
  type        = bool
  default     = false
}

variable "vpc_config" {
  description = "Provide this to allow your function to access your VPC."
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "tracing_config" {
  description = "Provide this to configure tracing."
  type = object({
    mode = string
  })
  default = null
}

variable "lambda_environment" {
  description = "The Lambda environment's configuration settings."
  type = object({
    variables = map(string)
  })
  default = null
}

variable "trigger" {
  description = "trigger configuration for this lambda function"
  type        = map(string)
}

variable "cloudwatch_log_subscription" {
  description = "cloudwatch log stream configuration"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for this lambda function"
  default     = {}
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions  for this lambda function"
  default     = -1
  type        = number
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "enable_cloudwatch_log_subscription" {
  type    = bool
  default = false
}

variable "cloudwatch_log_retention" {
  type    = number
  default = 90
}

variable "lambda_src_artifact_path" {
  type    = string
  default = "../../../lambda_artefacts"
}

variable "source_code_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key."
  type        = string
  default     = null
}