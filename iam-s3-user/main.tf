data "aws_iam_policy_document" "default" {
  count = var.enabled == "true" ? 1 : 0

  statement {
    actions   = [var.s3_actions]
    resources = [var.s3_resources]
    effect    = "Allow"
  }
}

module "s3_user" {
  source        = "git::ssh://git@github.com/dieple/terraform-modules-012x.git//iam-system-user?ref=tags/v0.0.1"
  enabled       = var.enabled
  user_id       = var.name
  pgp_key       = var.pgp_key
  tags          = var.tags
  force_destroy = var.force_destroy
  path          = var.path
}

resource "aws_iam_user_policy" "default" {
  count  = var.enabled == "true" ? 1 : 0
  name   = module.s3_user.user_name
  user   = module.s3_user.user_name
  policy = join("", data.aws_iam_policy_document.default.*.json)
}
