resource "aws_lambda_permission" "allow_invocation_from_cognito_idp" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "cognito-idp.amazonaws.com"
}
