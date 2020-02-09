locals {
  public_key_filename  = format("%s/%s%s", var.ssh_public_key_path, var.key_name, var.public_key_extension)
  private_key_filename = format("%s/%s%s", var.ssh_public_key_path, var.key_name, var.private_key_extension)
}

resource "aws_key_pair" "imported" {
  count      = var.generate_ssh_key == false ? 1 : 0
  key_name   = var.key_name
  public_key = file(local.public_key_filename)
}

resource "tls_private_key" "default" {
  count     = var.generate_ssh_key == true ? 1 : 0
  algorithm = var.ssh_key_algorithm
}

resource "aws_key_pair" "generated" {
  count      = var.generate_ssh_key == true ? 1 : 0
  depends_on = ["tls_private_key.default"]
  key_name   = var.key_name
  public_key = tls_private_key.default.public_key_openssh
}

resource "local_file" "public_key_openssh" {
  count      = var.generate_ssh_key == true ? 1 : 0
  depends_on = ["tls_private_key.default"]
  content    = tls_private_key.default.public_key_openssh
  filename   = local.public_key_filename
}

resource "local_file" "private_key_pem" {
  count      = var.generate_ssh_key == true ? 1 : 0
  depends_on = ["tls_private_key.default"]
  content    = tls_private_key.default.private_key_pem
  filename   = local.private_key_filename
}

resource "null_resource" "chmod" {
  count      = var.generate_ssh_key == true && var.chmod_command != "" ? 1 : 0
  depends_on = ["local_file.private_key_pem"]

  triggers = {
    local_file_private_key_pem = "local_file.private_key_pem"
  }

  provisioner "local-exec" {
    command = format(var.chmod_command, local.private_key_filename)
  }
}
