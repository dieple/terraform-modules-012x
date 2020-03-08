output "output_md5" {
  value = var.enabled ? data.external.archive[0].result.output_md5 : ""
}

output "output_path" {
  value = var.output_path
}

output "output_sha" {
  value = var.enabled ? data.external.archive[0].result.output_sha : ""
}

output "output_base64sha256" {
  value = var.enabled ? data.external.archive[0].result.output_base64sha256 : ""
}

output "search" {
  value = var.search
}

output "search_results" {
  value = jsondecode(var.enabled ? data.external.archive[0].result.search_results : "[]")
}

output "source_dir" {
  value = var.source_dir
}
