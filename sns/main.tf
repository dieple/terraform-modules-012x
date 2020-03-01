resource "aws_sns_topic" "this" {
  count        = var.create_sns_topic
  name         = var.sns_topic_name
  display_name = var.display_name == "" ? var.sns_topic_name : var.display_name
  tags         = var.tags
}
