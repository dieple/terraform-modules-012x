output "registry_ids" {
  value = aws_ecr_repository.repository.*.registry_id
}

output "repository_urls" {
  value = aws_ecr_repository.repository.*.repository_url
}

output "repository_names" {
  value = aws_ecr_repository.repository.*.name
}
