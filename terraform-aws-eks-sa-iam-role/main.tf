

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_oidc_assume_role" {
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
  name                  = "${var.cluster_name}-${var.name}-role"
  description           = "Permissions required by the Kubernetes AWS ALB Ingress controller"
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.eks_oidc_assume_role.json

  tags = var.tags
}

##############
# IAM Policy #
##############
resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-${var.name}-policy"
  description = "Permissions that are given to Service Account on EKS"
  policy      = var.sa_iam_policy_json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}
