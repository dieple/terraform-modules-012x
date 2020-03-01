resource "aws_iam_user" "default" {
  count         = var.enabled == true ? 1 : 0
  name          = var.user_id
  path          = var.path
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_iam_access_key" "default" {
  count   = var.enabled == true ? 1 : 0
  user    = aws_iam_user.default.name
  pgp_key = base64encode(file(var.pgp_key))
}

resource "aws_iam_user_policy" "default" {
  count  = var.enabled == true ? 1 : 0
  name   = "${aws_iam_user.default.name}-policy"
  user   = aws_iam_user.default.name
  policy = var.policy
}
