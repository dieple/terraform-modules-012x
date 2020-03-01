# iam-role


A Terraform module that creates IAM role with provided JSON IAM polices documents.

---

## Usage

This example creates a role with with permission to grant read-write access to S3 bucket,
and gives permission to the entities specified in `principals_arns` to assume the role.

```hcl

  data "aws_iam_policy_document" "resource_full_access" {
    statement {
      sid       = "FullAccess"
      effect    = "Allow"
      resources = ["arn:aws:s3:::bucketname/path/*"]

      actions = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:GetBucketLocation",
        "s3:AbortMultipartUpload",
      ]
    }
  }

  data "aws_iam_policy_document" "base" {
    statement {
      sid = "BaseAccess"

      actions = [
        "s3:ListBucket",
        "s3:ListBucketVersions",
      ]

      resources = ["arn:aws:s3:::bucketname"]
      effect    = "Allow"
    }
  }

  module "tag_label" {
  source = "../../modules/terraform-tagging"

  enabled     = var.enabled
  customer    = var.customer
  product     = var.product
  environment = var.environment
  attributes  = ["my-iam-role"]
  delimiter   = var.delimiter
  cost_centre = var.cost_centre
  tags        = {}
}

  module "role" {
    source     = "git::https://github.com/travelex/terraform-aws-iam-role.git?ref=......"

    enabled            = var.enabled
    name               = module.tag_label.id
    policy_description = "Allow S3 FullAccess"
    role_description   = "IAM role with permissions to perform actions on S3 resources"

    principals = {
      AWS = ["arn:aws:iam::123456789012:role/workers"]
    }

    # alternatively...
    #principals = {
    #  Service = ["ec2.amazonaws.com", "eks.amazonaws.com"]
    #}

    policy_documents = [
      "${data.aws_iam_policy_document.resource_full_access.json}",
      "${data.aws_iam_policy_document.base.json}",
    ]
  }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enabled | Set to `false` to prevent the module from creating any resources | string | `true` | no |
| max_session_duration | The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours | string | `3600` | no |
| name | Role Name | string | - | yes |
| policy_description | The description of the IAM policy that is visible in the IAM policy manager | string | - | yes |
| policy_document_count | Number of policy documents (length of policy_documents list). | string | `1` | no |
| policy_documents | List of JSON IAM policy documents | list | `<list>` | no |
| additional_policy_arns | List of additional policy arns | list | `<list>` | no |
| principals | Map of service name as key and a list of ARNs to allow assuming the role as value. (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`))) | map | `<map>` | no |
| role_description | The description of the IAM role that is visible in the IAM role manager | string | - | yes |
| create_ec2_profile | Flag set to true to create EC2 role profile | boolean | - | false |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) specifying the role |
| id | The stable and unique string identifying the role |
| name | The name of the IAM role created |
| policy | Role policy document in json format. Outputs always, independent of `enabled` variable |
