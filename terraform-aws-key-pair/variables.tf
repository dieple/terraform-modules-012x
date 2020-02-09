variable "key_name" {
  description = "Application or solution name (e.g. `app`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key directory (e.g. `/secrets`)"
}

variable "generate_ssh_key" {
  default     = false
  description = "If set to `true`, new SSH key pair will be created"
}

variable "ssh_key_algorithm" {
  default     = "RSA"
  description = "SSH key algorithm"
}

variable "private_key_extension" {
  default     = ""
  description = "Private key extension"
}

variable "public_key_extension" {
  default     = ".pub"
  description = "Public key extension"
}

variable "chmod_command" {
  default     = "chmod 600 %v"
  description = "Template of the command executed on the private key file"
}
