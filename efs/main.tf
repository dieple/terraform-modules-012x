locals {
  dns_name = "${join("", aws_efs_file_system.default.*.id)}.efs.${var.aws_region}.amazonaws.com"
}

resource "aws_efs_file_system" "default" {
  tags                            = var.tags
  encrypted                       = var.encrypted
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
}

resource "aws_efs_mount_target" "default" {
  count           = signum(length(var.availability_zones)) == 1 ? length(var.availability_zones) : 0
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = element(var.subnets, count.index)
  security_groups = [join("", aws_security_group.default.*.id)]
}

resource "aws_security_group" "default" {
  name        = format("%s-%s", var.name, "sg")
  description = "EFS"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "2049"                     # NFS
    to_port         = "2049"
    protocol        = "tcp"
    security_groups = [var.security_groups]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

module "dns" {
  source  = "git::ssh://git@github.com/dieple/terraform-modules-012x.git//route53-cluster-hostname"
  name    = var.dns_name == "" ? var.name : var.dns_name
  ttl     = 60
  zone_id = var.zone_id
  records = [local.dns_name]
}
