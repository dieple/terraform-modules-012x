# terraform-aws-tagging

Terraform module designed to generate consistent label names and tags for resources. Use `terraform-aws-tagging` to implement a strict naming convention.


A label follows the following convention: `{customer}-{product}-{environment}-{attributes}`. The delimiter (e.g. `-`) is interchangeable.

It's recommended to use one `terraform-aws-tagging` module for every unique resource of a given resource type.
For example, if you have 10 instances, there should be 10 different labels.
However, if you have multiple different kinds of resources (e.g. instances, security groups, file systems, and elastic IPs), then they can all share the same label assuming they are logically related.

### Simple Example

Include this repository as a module in your existing terraform code:

```hcl
module "label" {
  source      = "git::https://github.com/travelex/terraform-aws-label.git?ref=<release-tag-version>"

  customer    = "tvx"
  product     = "plfm"
  environment = "tst"
  attributes  = ["eks"]
  delimiter   = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}
```

This will create an `id` with the value of `tvx-plfm-tst-eks`.

Now reference the label when creating an eks cluster (for example):

```hcl
resource "aws_eks_cluster" "my_eks_cluster" {
  name  = module.label.id
  tags  = module.label.tags
  etc
}
```

Or define a security group:

```hcl
resource "aws_security_group" "my_sg" {
  vpc_id = var.vpc_id
  name   = module.label.id
  tags   = module.label.tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```


### Advanced Example

Here is a more complex example with two instances using two different labels. Note how efficiently the tags are defined for both the instance and the security group.

```hcl
module "bastion_abc_label" {
  source      = "git::https://github.com/travelex/terraform-aws-label.git?ref=<release-tag-version>"
  customer    = "tvx"
  product     = "plfm"
  environment = "tst"
  attributes  = ["eks"]
  delimiter   = "-"

  tags = {
    "BusinessUnit" = "ABC"
  }
}

resource "aws_security_group" "bastion_abc_sg" {
  name = module.bastion_abc_label.id
  tags = module.bastion_abc_label.tags
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_abc_instance" {
  instance_type          = "t1.micro"
  tags                   = module.bastion_abc_label.tags
  vpc_security_group_ids = [aws_security_group.bastion_abc_label.id]
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| convert_case | Convert fields to lower case | bool | `true` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| customer | Customer Name name, e.g. `tvx` or `swych` | string | `` | no |
| product | Product, e.g. "payment"  | string | `` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev' | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Disambiguated ID |
| tags | Normalized Tag map |
