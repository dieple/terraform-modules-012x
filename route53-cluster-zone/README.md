# route53-cluster-zone


Terraform module to easily define consistent cluster domains on `Route53`.

## Usage


Define a cluster domain of `foobar.example.com` using a custom naming convention for `zone_name`.
The `zone_name` variable is optional. It defaults to `$${environment}.$${parent_zone_name}`.

```hcl
module "domain" {
  source               = "git::https://github.com/dieple/terraform-modules-012x.git//route53-cluster-zone?ref=tags/v0.0.1"
  environment          = "tst"
  name                 = "k8s"
  parent_zone_name     = "digital.example.io"
  zone_name            = "$${name}.$${environment}.$${parent_zone_name}"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enabled | Set to false to prevent the module from creating or accessing any resources | bool | `true` | no |
| parent_zone_id | ID of the hosted zone to contain this record  (or specify `parent_zone_name`) | string | `` | no |
| parent_zone_name | Name of the hosted zone to contain this record (or specify `parent_zone_id`) | string | `` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map('BusinessUnit','XYZ') | map(string) | `<map>` | no |
| zone_name | Zone name | string | `$${name}.$${stage}.$${parent_zone_name}` | no |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | Fully-qualified domain name |
| parent_zone_id | ID of the hosted zone to contain this record |
| parent_zone_name | Name of the hosted zone to contain this record |
| zone_id | Route53 DNS Zone ID |
| zone_name | Route53 DNS Zone name |
