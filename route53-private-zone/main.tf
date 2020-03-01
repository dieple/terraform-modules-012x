locals {
  description = "Private zone for ${var.zone_name}"
}

resource "aws_route53_zone" "main" {
  name          = var.zone_name
  comment       = local.description
  force_destroy = var.force_destroy
  tags          = var.tags

  vpc {
    vpc_id = var.main_vpc
  }
}

resource "aws_route53_zone_association" "secondary" {
  count   = length(var.secondary_vpcs)
  zone_id = aws_route53_zone.main.zone_id
  vpc_id  = var.secondary_vpcs[count.index]
}

data "aws_route53_zone" "parent" {
  name         = var.parent_zone_name
  private_zone = false
}

resource "aws_route53_record" "parent_ns" {
  zone_id = data.aws_route53_zone.parent.zone_id
  name    = var.zone_name
  type    = "NS"
  ttl     = "300"

  records = [
    aws_route53_zone.main.name_servers[0],
    aws_route53_zone.main.name_servers[1],
    aws_route53_zone.main.name_servers[2],
    aws_route53_zone.main.name_servers[3],
  ]
}
