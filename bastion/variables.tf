variable "bastion_name" {
  description = "Name  (e.g. `app` or `bastion`)"
  type        = string
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}

variable "service_port" {
  description = "port for the service to listen on"
  type        = number
  default     = 4080
}

# ASG variables

variable "public_subnets" {
  description = "List of subnets for the ASG"
  type        = list(string)
}

variable "aws_ssh_key_file" {
  default = "default"
}

variable "jump_alias" {
  type        = string
  description = "DNS Name of jump box"
  default     = "bastion"
}

variable "vpc_id" {
  description = "VPC to use"
  type        = string
}

variable "environment" {
  description = "Environment, normally prod, staging, test or dev"
  type        = string
}

variable "zone_id" {
  type        = string
  description = "Route53 Public Zone ID"
}

variable "key_name" {
  type        = string
  description = "SSH key"
}

variable "volume_size" {
  type    = number
  default = 50
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_user" {
  default = "ec2-user"
  type    = string
}

variable "public_key_data" {
  type    = string
  default = ""
}

variable "user_data" {
  type        = list(string)
  default     = []
  description = "User data content"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "A list of CIDR blocks allowed to connect"

  default = [
    "0.0.0.0/0",
  ]
}

variable "max_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "scale_up_cron" {
  type = string
}

variable "scale_down_cron" {
  type = string
}

variable "scale_down_min_size" {
  type = string
}

variable "scale_down_desired_capacity" {
  type = string
}

variable "cooldown" {}

variable "health_check_grace_period" {}

variable "wait_for_capacity_timeout" {
  type        = string
  default     = "10m"
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior"
}

variable "cpu_utilization_high_threshold_percent" {
  type        = number
  default     = 80
  description = "CPU utilization high threshold"
}

variable "cpu_utilization_low_threshold_percent" {
  type        = number
  default     = 20
  description = "CPU utilization loq threshold"
}
