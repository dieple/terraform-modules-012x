resource "aws_kms_key" "this" {
  count                   = var.enabled == true ? 1 : 0
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = var.policy
  tags                    = var.tags
}

resource "aws_kms_alias" "this" {
  depends_on = [
    aws_kms_key.this,
  ]
  count         = var.enabled == true ? 1 : 0
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this[count.index].key_id
}