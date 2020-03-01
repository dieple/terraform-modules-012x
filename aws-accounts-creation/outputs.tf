output "aws_account_ids" {
  value = aws_organizations_account.account.*.id
}

output "aws_account_arns" {
  value = aws_organizations_account.account.*.arn
}

