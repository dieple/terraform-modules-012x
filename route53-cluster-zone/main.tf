data "aws_region" "default" {
}

data "template_file" "zone_name" {
  count    = var.enabled ? 1 : 0
  template = replace(var.zone_name, "$$", "$")

  vars = {
    parent_zone_name = join("", null_resource.parent.*.triggers.zone_name)
    region           = data.aws_region.default.name
    name             = var.name
    environment      = var.environment
  }
}

resource "null_resource" "parent" {
  count = var.enabled ? 1 : 0

  triggers = {
    zone_id = format(
      "%v",
      length(var.parent_zone_id) > 0 ? join(" ", data.aws_route53_zone.parent_by_zone_id.*.zone_id) : join(" ", data.aws_route53_zone.parent_by_zone_name.*.zone_id),
    )
    zone_name = format(
      "%v",
      length(var.parent_zone_id) > 0 ? join(" ", data.aws_route53_zone.parent_by_zone_id.*.name) : join(" ", data.aws_route53_zone.parent_by_zone_name.*.name),
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "parent_by_zone_id" {
  count   = var.enabled ? signum(length(var.parent_zone_id)) : 0
  zone_id = var.parent_zone_id
}

data "aws_route53_zone" "parent_by_zone_name" {
  count = var.enabled ? signum(length(var.parent_zone_name)) : 0
  name  = var.parent_zone_name
}

resource "aws_route53_zone" "default" {
  count = var.enabled ? 1 : 0
  name  = join("", data.template_file.zone_name.*.rendered)
  tags  = var.tags
}

resource "aws_route53_record" "ns" {
  count   = var.enabled ? 1 : 0
  zone_id = join("", null_resource.parent.*.triggers.zone_id)
  name    = join("", aws_route53_zone.default.*.name)
  type    = "NS"
  ttl     = "60"

  records = [
    aws_route53_zone.default[0].name_servers[0],
    aws_route53_zone.default[0].name_servers[1],
    aws_route53_zone.default[0].name_servers[2],
    aws_route53_zone.default[0].name_servers[3],
  ]
}

