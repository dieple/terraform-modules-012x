data "aws_iam_policy_document" "assume_role" {
  count = length(keys(var.principals))

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = element(keys(var.principals), count.index)
      identifiers = var.principals[element(keys(var.principals), count.index)]
    }
  }
}

module "aggregated_assume_policy" {
  source           = "git::https://github.com/cloudposse/terraform-aws-iam-policy-document-aggregator.git?ref=tags/0.2.0"
  source_documents = data.aws_iam_policy_document.assume_role.*.json
}

resource "aws_iam_role" "default" {
  count                = var.enabled ? 1 : 0
  name                 = var.name
  assume_role_policy   = module.aggregated_assume_policy.result_document
  description          = var.role_description
  max_session_duration = var.max_session_duration
}

module "aggregated_policy" {
  source           = "git::https://github.com/cloudposse/terraform-aws-iam-policy-document-aggregator.git?ref=tags/0.2.0"
  source_documents = var.policy_documents
}

resource "aws_iam_policy" "default" {
  count       = var.enabled && var.policy_document_count > 0 ? 1 : 0
  name        = var.name
  description = var.policy_description
  policy      = module.aggregated_policy.result_document
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.enabled && var.policy_document_count > 0 ? 1 : 0
  role       = aws_iam_role.default[0].name
  policy_arn = aws_iam_policy.default[0].arn
}

resource aws_iam_role_policy_attachment "additional" {
  count      = length(var.additional_policy_arns)
  policy_arn = element(var.additional_policy_arns, count.index)
  role       = aws_iam_role.default[0].name
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_ec2_profile ? 1 : 0
  name  = "${var.name}-profile"
  role  = aws_iam_role.default[0].name
  path  = var.path

  lifecycle {
    create_before_destroy = true
  }
}
