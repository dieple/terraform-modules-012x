output "dlq-id" {
  description = "DLQ endpoint"
  value       = aws_sqs_queue.sqs-deadletter.*.id
}

output "dlq-arn" {
  description = "DLQ ARN"
  value       = aws_sqs_queue.sqs-deadletter.*.arn
}
