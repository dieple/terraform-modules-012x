
# terraform-aws-dynamodb

Terraform module to provision a DynamoDB table with autoscaling.

Autoscaler scales up/down the provisioned OPS for the DynamoDB table based on the load.

## Usage


```hcl
module "dynamodb_table" {
  source                       = "git::https://github.com/travelex/terraform-iac.git//modules/terraform-aws-dynamodb"
  customer                    = "eg"
  product                     = "dev"
  environment                 = "cluster"
  hash_key                     = "HashKey"
  range_key                    = "RangeKey"
  autoscale_write_target       = 50
  autoscale_read_target        = 50
  autoscale_min_read_capacity  = 5
  autoscale_max_read_capacity  = 20
  autoscale_min_write_capacity = 5
  autoscale_max_write_capacity = 20
  enable_autoscaler            = true

  dynamodb_attributes = [
    {
      name = "DailyAverage"
      type = "N"
    },
    {
      name = "HighWater"
      type = "N"
    },
    {
      name = "Timestamp"
      type = "S"
    }
  ]

  local_secondary_index_map = [
    {
      name               = "TimestampSortIndex"
      range_key          = "Timestamp"
      projection_type    = "INCLUDE"
      non_key_attributes = ["HashKey", "RangeKey"]
    },
    {
      name               = "HighWaterIndex"
      range_key          = "Timestamp"
      projection_type    = "INCLUDE"
      non_key_attributes = ["HashKey", "RangeKey"]
    }
  ]

  global_secondary_index_map = [
    {
      name               = "DailyAverageIndex"
      hash_key           = "DailyAverage"
      range_key          = "HighWater"
      write_capacity     = 5
      read_capacity      = 5
      projection_type    = "INCLUDE"
      non_key_attributes = ["HashKey", "RangeKey"]
    }
  ]
}
```

__NOTE:__ Variables "global_secondary_index_map" and "local_secondary_index_map" have a predefined schema, but in some cases not all fields are required or needed.

For example:
 * `non_key_attributes` can't be specified for Global Secondary Indexes (GSIs) when `projection_type` is `ALL`
 * `read_capacity` and `write_capacity` are not required for GSIs

In these cases, set the fields to `null` and Terraform will treat them as if they were not provided at all, but will not complain about missing values:

```hcl
  global_secondary_index_map = [
    {
      write_capacity     = null
      read_capacity      = null
      projection_type    = "ALL"
      non_key_attributes = null
    }
  ]
```

## Outputs

| Name | Description |
|------|-------------|
| global_secondary_index_names | DynamoDB secondary index names |
| local_secondary_index_names | DynamoDB local index names |
| table_arn | DynamoDB table ARN |
| table_id | DynamoDB table ID |
| table_name | DynamoDB table name |
| table_stream_arn | DynamoDB table stream ARN |
| table_stream_label | DynamoDB table stream label |
