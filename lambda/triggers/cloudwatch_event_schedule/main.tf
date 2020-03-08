resource "aws_cloudwatch_event_rule" "rule" {
  count               = var.enable ? 1 : 0
  name                = lookup(var.schedule_config, "name")
  description         = lookup(var.schedule_config, "description")
  schedule_expression = lookup(var.schedule_config, "schedule_expression")
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = var.enable ? 1 : 0
  rule  = element(aws_cloudwatch_event_rule.rule.*.name, count.index)
  arn   = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = element(aws_cloudwatch_event_rule.rule.*.arn, count.index)
}
