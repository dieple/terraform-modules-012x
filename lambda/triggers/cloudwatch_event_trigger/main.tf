resource "aws_cloudwatch_event_rule" "event_rule" {
  count         = var.enable ? 1 : 0
  name          = lookup(var.event_config, "name")
  description   = lookup(var.event_config, "description")
  event_pattern = lookup(var.event_config, "event_pattern")
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = var.enable ? 1 : 0
  rule  = element(aws_cloudwatch_event_rule.event_rule.*.name, count.index)
  arn   = var.lambda_function_arn
}

resource "aws_lambda_permission" "invoke-from-events" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = element(aws_cloudwatch_event_rule.event_rule.*.arn, count.index)

}
