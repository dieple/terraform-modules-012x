terraform {
  required_version = ">= 0.12.0"
}

data "external" "archive" {
  count = var.enabled ? 1 : 0

  program = ["python", "${path.module}/zip.py"]
  query = {
    empty_dirs  = jsonencode(var.empty_dirs)
    source_dir  = var.source_dir
    output_path = var.output_path
    search      = jsonencode(var.search)
  }
}

