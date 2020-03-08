locals {
  cloudwatch_log_group = "/aws/lambda/${var.function_name}"
}

resource "aws_lambda_function" "lambda" {
  filename                       = var.file_name
  function_name                  = var.function_name
  source_code_hash               = var.source_code_hash
  layers                         = var.layers
  handler                        = var.handler
  role                           = var.role_arn
  description                    = var.description
  memory_size                    = var.memory_size
  runtime                        = var.runtime
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish
  tags                           = var.tags


  dynamic "environment" {
    for_each = var.lambda_environment == null ? [] : [var.lambda_environment]

    content {
      variables = environment.value.variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config == null ? [] : [var.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]

    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = local.cloudwatch_log_group
  retention_in_days = var.cloudwatch_log_retention
}

module "triggered-by-cloudwatch-event-schedule" {
  enable              = lookup(var.trigger, "type", "") == "cloudwatch-event-schedule" ? true : false
  source              = "./triggers/cloudwatch_event_schedule/"
  lambda_function_arn = aws_lambda_function.lambda.arn

  schedule_config = {
    name                = var.function_name
    description         = var.description
    schedule_expression = lookup(var.trigger, "schedule_expression", "")
  }
}

module "triggered-by-cloudwatch-event-trigger" {
  enable              = lookup(var.trigger, "type", "") == "cloudwatch-event-trigger" ? true : false
  source              = "./triggers/cloudwatch_event_trigger/"
  lambda_function_arn = aws_lambda_function.lambda.arn

  event_config = {
    name          = var.function_name
    description   = var.description
    event_pattern = lookup(var.trigger, "event_pattern", "")
  }
}

module "triggered-by-step-function" {
  enable              = lookup(var.trigger, "type", "") == "step-function" ? true : false
  source              = "./triggers/step_function/"
  lambda_function_arn = aws_lambda_function.lambda.arn
  region              = var.region
}

module "triggered-by-api-gateway" {
  enable              = lookup(var.trigger, "type", "") == "api-gateway" ? true : false
  source              = "./triggers/api_gateway/"
  lambda_function_arn = aws_lambda_function.lambda.arn
}

module "triggered-by-cognito-idp" {
  enable              = lookup(var.trigger, "type", "") == "cognito-idp" ? true : false
  source              = "./triggers/cognito_idp/"
  lambda_function_arn = aws_lambda_function.lambda.arn
}

module "triggered-by-cloudwatch-logs" {
  enable              = lookup(var.trigger, "type", "") == "cloudwatch-logs" ? true : false
  source              = "./triggers/cloudwatch_logs/"
  lambda_function_arn = aws_lambda_function.lambda.arn
  region              = var.region
}

module "triggered-by-sqs" {
  enable              = lookup(var.trigger, "type", "") == "sqs" ? true : false
  source              = "./triggers/sqs/"
  lambda_function_arn = aws_lambda_function.lambda.arn

  sqs_config = {
    sns_topic_arn              = lookup(var.trigger, "sns_topic_arn", "")
    sqs_name                   = var.function_name
    visibility_timeout_seconds = var.timeout + 5
    batch_size                 = lookup(var.trigger, "batch_size", 1)
  }

  tags = var.tags
}

module "triggered-by-s3-notification" {
  enable              = lookup(var.trigger, "type", "") == "s3" ? true : false
  source              = "./triggers/s3_notification/"
  lambda_function_arn = aws_lambda_function.lambda.arn
  bucket              = lookup(var.trigger, "bucket", "")
  events              = lookup(var.trigger, "events", "")
  principal           = lookup(var.trigger, "principal", "")
  source_arn          = lookup(var.trigger, "source_arn", "")
}

module "cloudwatch-log-subscription" {
  enable                      = var.enable_cloudwatch_log_subscription ? true : false
  source                      = "./log_subscription/"
  lambda_name                 = aws_lambda_function.lambda.function_name
  log_group_name              = aws_cloudwatch_log_group.lambda.name
  cloudwatch_log_subscription = var.cloudwatch_log_subscription
}
