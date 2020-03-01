output "user_name" {
  value       = "${join("", aws_iam_user.default.*.name)}"
  description = "Normalized IAM user name"
}

output "user_arn" {
  value       = "${join("", aws_iam_user.default.*.arn)}"
  description = "The ARN assigned by AWS for this user"
}

output "user_unique_id" {
  value       = "${join("", aws_iam_user.default.*.unique_id)}"
  description = "The unique ID assigned by AWS"
}

output "access_key_id" {
  value       = "${join("", aws_iam_access_key.default.*.id)}"
  description = "The access key ID"
}

output "secret_access_key" {
  sensitive   = true
  value       = "${join("", aws_iam_access_key.default.*.secret)}"
  description = "The IAM user secret access key, encrypted with the PGP key supplied and b64 encoded in the output. Base64 decode this output and supply to gpg to decrypt."
}
