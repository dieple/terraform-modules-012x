data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_oidc_assume_role" {
  count = var.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.sa_ns}:${var.name}"
      ]
    }
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.oidc_provider, "https://", "")}"
      ]
      type = "Federated"
    }
  }
}

############
# IAM Role #
############
resource "aws_iam_role" "this" {
  count                 = var.enabled ? 1 : 0
  name                  = "${var.cluster_name}-${var.name}-role"
  description           = "Role that will be used to annotate Service Account on EKS"
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.eks_oidc_assume_role[0].json

  tags = var.tags
}

##############
# IAM Policy #
##############
resource "aws_iam_policy" "this" {
  count       = var.enabled ? 1 : 0
  name        = "${var.cluster_name}-${var.name}-policy"
  description = "Permissions that are given to Service Account on EKS"
  policy      = var.sa_iam_policy_json
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.enabled ? 1 : 0
  policy_arn = aws_iam_policy.this[0].arn
  role       = aws_iam_role.this[0].name
}