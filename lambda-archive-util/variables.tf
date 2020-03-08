variable "empty_dirs" {
  type    = bool
  default = false
}

variable "enabled" {
  type    = bool
  default = true
}

variable "output_path" {
  type = string
}

variable "search" {
  type    = list(string)
  default = []
}

variable "source_dir" {
  type = string
}

