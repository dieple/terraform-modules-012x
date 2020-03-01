resource "aws_s3_bucket" "default" {
  bucket        = var.name
  acl           = var.acl
  region        = var.region
  force_destroy = var.force_destroy
  policy        = var.policy

  versioning {
    enabled = var.versioning_enabled
  }

  # https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html
  # https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#enable-default-server-side-encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_id
      }
    }
  }

  tags = var.tags
}

module "s3_user" {
  source       = "git::ssh://git@github.com/dieple/terraform-modules-012x.git//iam-s3-user"
  enabled      = var.user_enabled
  name         = var.name
  pgp_key      = var.pgp_key
  tags         = var.tags
  s3_actions   = [var.allowed_bucket_actions]
  s3_resources = ["${aws_s3_bucket.default.arn}/*", "${aws_s3_bucket.default.arn}"]
}

data "aws_iam_policy_document" "bucket_policy" {
  count = var.allow_encrypted_uploads_only == true ? 1 : 0

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.default.id}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "StringNotEquals"
      values   = ["${var.sse_algorithm}"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.default.id}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "Null"
      values   = ["true"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }
}

resource "aws_s3_bucket_policy" "default" {
  count  = var.allow_encrypted_uploads_only == true ? 1 : 0
  bucket = aws_s3_bucket.default.id

  policy = join("", data.aws_iam_policy_document.bucket_policy.*.json)
}
