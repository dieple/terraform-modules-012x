locals {
  sns_topics = compact(split(",", chomp(replace(lookup(var.sqs_config, "sns_topic_arn", ""), "\n", ""))))
  enabled    = var.enable ? 1 : 0
}

resource "aws_sqs_queue" "sqs-deadletter" {
  count = local.enabled
  name  = "${lookup(var.sqs_config, "sqs_name")}-dlq"

  tags = var.tags
}

resource "aws_sqs_queue" "sqs" {
  count                      = local.enabled
  name                       = lookup(var.sqs_config, "sqs_name")
  visibility_timeout_seconds = lookup(var.sqs_config, "visibility_timeout_seconds")

  redrive_policy = <<EOF
{
  "deadLetterTargetArn": "${element(aws_sqs_queue.sqs-deadletter.*.arn, 0)}",
  "maxReceiveCount": 12
}
EOF

  tags = var.tags
}

data "aws_iam_policy_document" "SendMessage" {
  count = local.enabled

  statement {
    effect    = "Allow"
    actions   = list("SQS:SendMessage")
    resources = [element(aws_sqs_queue.sqs.*.arn, 0)]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:ArnLike"
      variable = "aws:SourceArn"
      values   = local.sns_topics
    }
  }
}

resource "aws_sqs_queue_policy" "SendMessage" {
  count     = local.enabled * length(local.sns_topics) >= 1 ? 1 : 0
  queue_url = element(aws_sqs_queue.sqs.*.id, 0)
  policy    = data.aws_iam_policy_document.SendMessage[count.index].json
}

resource aws_sns_topic_subscription "to-sqs" {
  count     = local.enabled * length(local.sns_topics)
  protocol  = "sqs"
  topic_arn = trimspace(element(local.sns_topics, count.index))
  endpoint  = element(aws_sqs_queue.sqs.*.arn, 0)
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  count            = local.enabled
  batch_size       = lookup(var.sqs_config, "batch_size")
  event_source_arn = element(aws_sqs_queue.sqs.*.arn, 0)
  enabled          = true
  function_name    = var.lambda_function_arn
}
