output "sa_iam_role_arn" {
  value       = join("", aws_iam_role.this.*.arn)
  description = "Service Account IAM role Arn"
}
