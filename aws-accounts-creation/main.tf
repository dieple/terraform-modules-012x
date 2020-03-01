resource "aws_organizations_account" "account" {
  for_each                   = var.account_data

  name                       = each.value["name"]
  email                      = each.value["email"]
  iam_user_access_to_billing = each.value["account_iam_billing"]
  tags                       = var.tags
}