resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  count  = var.enable ? 1 : 0
  bucket = var.bucket

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = split(",", var.events)
  }
}

# Add lambda permissions for acting on various triggers.
resource "aws_lambda_permission" "s3_bucket_notification_allow_source" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = var.principal
  source_arn    = var.source_arn
}
