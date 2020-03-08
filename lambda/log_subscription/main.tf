resource "aws_cloudwatch_log_subscription_filter" "lambda_cloudwatch_subscription" {
  count           = var.enable ? 1 : 0
  name            = var.lambda_name
  log_group_name  = var.log_group_name
  filter_pattern  = lookup(var.cloudwatch_log_subscription, "filter_pattern", "")
  destination_arn = lookup(var.cloudwatch_log_subscription, "destination_arn", "")
}
