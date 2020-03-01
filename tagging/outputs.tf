# id is used to have consistent "resource" naming conventions"
output "id" {
  value       = local.id
  description = "Disambiguated ID"
}

output "tags" {
  value       = local.tags
  description = "Normalized Tag map"
}
