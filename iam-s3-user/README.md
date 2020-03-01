# iam-s3-user


Terraform module to provision a basic IAM user with permissions to access S3 resources, e.g. to give the user read/write/delete access to the objects in an S3 bucket.

Suitable for CI/CD systems (_e.g._ TravisCI, CircleCI, CodeFresh) or systems which are *external* to AWS that cannot leverage [AWS IAM Instance Profiles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html).


---

## Usage

This example will create an IAM user and allow read access to all objects in the S3 bucket `examplebucket`


```hcl
module "s3_user" {
  source       = "git::https://github.com/dieple/terraform-module-012x.git//iam-s3-user?ref=tags/v0.0.1"
  name         = var.name 
  s3_actions   = ["s3:GetObject"]
  s3_resources = ["arn:aws:s3:::examplebucket/*"]
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| force_destroy | Destroy even if it has non-Terraform-managed IAM access keys, login profiles or MFA devices | string | `false` | no |
| name | Application or solution name (e.g. `app`) | string | - | yes |
| path | Path in which to create the user | string | `/` | no |
| s3_actions | Actions to allow in the policy | list | `<list>` | no |
| s3_resources | S3 resources to apply the actions specified in the policy | list | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| access_key_id | The access key ID |
| secret_access_key | The secret access key. This will be written to the state file in plain-text |
| user_arn | The ARN assigned by AWS for the user |
| user_name | Normalized IAM user name |
| user_unique_id | The user unique ID assigned by AWS |


