resource "aws_lambda_permission" "allow_apigateway" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "apigateway.amazonaws.com"
}
