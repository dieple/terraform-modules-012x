resource "aws_route53_zone" "zone" {
  name = var.zone_name
  tags = var.tags
}

resource "aws_route53_record" "record" {
  count   = length(var.records)
  zone_id = aws_route53_zone.zone.zone_id
  name    = element(split(",",var.records[count.index]), 0)
  type    = element(split(",",var.records[count.index]), 1)
  records = [split("|",element(split(",",var.records[count.index]), 2))]
  ttl     = element(split(",",var.records[count.index]), 3) != "default" ? element(split(",",var.records[count.index]), 3) : var.ttl_default
}
