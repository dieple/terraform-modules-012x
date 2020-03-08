resource "aws_lambda_permission" "allow_invocation_from_sfn" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromSfn"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "states.${var.region}.amazonaws.com"
}
