output "arn" {
  value       = aws_efs_file_system.default.arn
  description = "EFS ARN"
}

output "id" {
  value       = aws_efs_file_system.default.id
  description = "EFS ID"
}

output "host" {
  value       = module.dns.hostname
  description = "Route53 DNS hostname for the EFS"
}

output "dns_name" {
  value       = local.dns_name
  description = "EFS DNS name"
}

output "mount_target_dns_names" {
  value       = [coalescelist(aws_efs_mount_target.default.*.dns_name, list(""))]
  description = "List of EFS mount target DNS names"
}

output "mount_target_ids" {
  value       = [coalescelist(aws_efs_mount_target.default.*.id, list(""))]
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = [coalescelist(aws_efs_mount_target.default.*.ip_address, list(""))]
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "network_interface_ids" {
  value       = [coalescelist(aws_efs_mount_target.default.*.network_interface_id, list(""))]
  description = "List of mount target network interface IDs"
}
