# terraform-aws-dynamodb-autoscaler

Terraform module to provision DynamoDB autoscaler.

Autoscaler scales up/down the provisioned OPS for a DynamoDB table based on the load.

## Usage


```hcl
module "dynamodb_autoscaler" {
  source                       = "git::https://github.com/travelex/platform-iac.git//modules/terraform-aws-dynamodb-autoscaler"
  namespace                    = "eg"
  stage                        = "dev"
  name                         = "cluster"
  dynamodb_table_name          = "eg-dev-cluster-terraform-state-lock"
  dynamodb_indexes             = ["first-index", "second-index"]
  dynamodb_table_arn           = "arn:aws:dynamodb:us-east-1:123456789012:table/eg-dev-cluster-terraform-state-lock"
  autoscale_write_target       = 50
  autoscale_read_target        = 50
  autoscale_min_read_capacity  = 5
  autoscale_max_read_capacity  = 20
  autoscale_min_write_capacity = 5
  autoscale_max_write_capacity = 20
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autoscale_max_read_capacity | DynamoDB autoscaling max read capacity | number | `20` | no |
| autoscale_max_write_capacity | DynamoDB autoscaling max write capacity | number | `20` | no |
| autoscale_min_read_capacity | DynamoDB autoscaling min read capacity | number | `5` | no |
| autoscale_min_write_capacity | DynamoDB autoscaling min write capacity | number | `5` | no |
| autoscale_read_target | The target value for DynamoDB read autoscaling | number | `50` | no |
| autoscale_write_target | The target value for DynamoDB write autoscaling | number | `50` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | string | `-` | no |
| dynamodb_indexes | List of DynamoDB indexes | list(string) | `<list>` | no |
| dynamodb_table_arn | DynamoDB table ARN | string | - | yes |
| dynamodb_table_name | DynamoDB table name | string | - | yes |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| appautoscaling_read_target_id | Appautoscaling read target ID |
| appautoscaling_read_target_index_id | Appautoscaling read target index ID |
| appautoscaling_write_target_id | Appautoscaling write target ID |
| appautoscaling_write_target_index_id | Appautoscaling write target index ID |
| autoscaler_iam_role_arn | Autoscaler IAM Role ARN |
| autoscaler_iam_role_id | Autoscaler IAM Role ID |
