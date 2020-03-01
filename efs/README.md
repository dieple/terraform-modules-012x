
# terraform-aws-efs


Terraform module to provision an AWS [`EFS`](https://aws.amazon.com/efs/) Network File System.


---

## Usage

Include this repository as a module in your existing terraform code:

```hcl
module "efs" {
  source     = "git::https://github.com/dieple/terraform-modules-012x.git//efs?ref=tags/v0.0.1"
  name       = var.name

  aws_region         = var.aws_region
  vpc_id             = var.vpc_id
  subnets            = [var.private_subnets]
  availability_zones = [var.availability_zones]
  security_groups    = [var.security_group_id]

  zone_id = var.aws_route53_dns_zone_id
}
```


```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability_zones | Availability Zone IDs | list | - | yes |
| aws_region | AWS Region | string | - | yes |
| dns_name | Name of the CNAME record to create. | string | `` | no |
| encrypted | If true, the disk will be encrypted | string | `false` | no |
| mount_target_ip_address | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target | string | `` | no |
| name | Name (_e.g._ `app`) | string | `app` | no |
| performance_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | string | `generalPurpose` | no |
| provisioned_throughput_in_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned | string | `0` | no |
| security_groups | Security group IDs to allow access to the EFS | list | - | yes |
| subnets | Subnet IDs | list | - | yes |
| tags | Additional tags (e.g. `{ BusinessUnit = "XYZ" }` | map | `<map>` | no |
| throughput_mode | Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps | string | `bursting` | no |
| vpc_id | VPC ID | string | - | yes |
| zone_id | Route53 DNS zone ID | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns_name | EFS DNS name |
| host | Route53 DNS hostname for the EFS |
| id | EFS ID |
| mount_target_dns_names | List of EFS mount target DNS names |
| mount_target_ids | List of EFS mount target IDs (one per Availability Zone) |
| mount_target_ips | List of EFS mount target IPs (one per Availability Zone) |
| network_interface_ids | List of mount target network interface IDs |


