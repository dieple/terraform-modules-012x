resource "aws_iam_role" "bastion_role" {
  name = format("%s-%s", var.bastion_name, "role")

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": ["ec2.amazonaws.com"]
        },
        "Effect": "Allow"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "bastion_role_policy" {
  name   = format("%s-%s", var.bastion_name, "role-policy")
  role   = aws_iam_role.bastion_role.id
  policy = data.aws_iam_policy_document.bastion_policy_document.json
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "bastion_policy_document" {
  statement {
    actions = [
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:EIPAssociation",
      "ec2:DisassociateAddress",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "bastion_policy" {
  name   = format("%s-%s", var.bastion_name, "iam-policy")
  policy = data.aws_iam_policy_document.bastion_policy_document.json
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = format("%s-%s", var.bastion_name, "instance-profile")
  path = "/"
  role = aws_iam_role.bastion_role.name
}

# EIP for instances
resource "aws_eip" "bastion" {
  vpc = true
}

# Get the name of the latest AMI for Amazon Linux
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami*_64-gp2"]
  }
}


data "local_file" "public_key" {
  filename = "${path.module}/key.pub"
}

data "template_file" "bastion_init_script" {
  template = file("${path.module}/user_data/user_data.sh")

  vars {
    allocation_id = aws_eip.bastion.id
    public_key    = var.public_key_data == "" ? data.local_file.public_key.content : var.public_key_data
    ssh_user      = var.ssh_user
    environment   = var.environment
    user_data     = join("\n", var.user_data)
    region        = data.aws_region.current.name
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = var.zone_id
  name    = "bastion"
  ttl     = "60"
  type    = "A"
  records = [aws_eip.bastion.public_ip]
}

#----------------------------------------------------
# This creates a new security group
#---------------------------------------------------

resource "aws_security_group" "allow_ssh_sg" {
  name        = format("%s-%s", var.bastion_name, "allow-ssh-sg")
  description = "Allow all SSH only inbound"
  vpc_id      = var.vpc_id
  tags        = var.tags

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create the configuration for an ASG
resource "aws_launch_configuration" "as_conf" {
  name_prefix          = format("%s-%s", var.bastion_name, "lc")
  image_id             = data.aws_ami.ami.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = [aws_security_group.allow_ssh_sg.id]
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.name
  enable_monitoring    = true

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
  }

  user_data = data.template_file.bastion_init_script.rendered
}

resource "aws_autoscaling_group" "bastion_asg" {
  name                      = format("%s-%s", var.bastion_name, "asg")
  vpc_zone_identifier       = [var.public_subnets]
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.as_conf.name
  max_size                  = var.max_size
  min_size                  = var.min_size
  default_cooldown          = var.cooldown
  health_check_grace_period = var.health_check_grace_period
  desired_capacity          = var.desired_capacity
  termination_policies      = ["ClosestToNextInstanceHour", "OldestInstance", "Default"]
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  tags                      = [data.null_data_source.tags_as_list_of_maps.*.outputs]

  lifecycle {
    create_before_destroy = true
  }
}

data "null_data_source" "tags_as_list_of_maps" {
  count = length(keys(var.tags))

  inputs = map(
    "key", element(keys(var.tags), count.index),
    "value", element(values(var.tags), count.index),
    "propagate_at_launch", true
  )
}

resource "aws_autoscaling_schedule" "scale_up" {
  autoscaling_group_name = aws_autoscaling_group.bastion_asg.name
  scheduled_action_name  = "Scale Up"
  recurrence             = var.scale_up_cron
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.desired_capacity
}

resource "aws_autoscaling_schedule" "scale_down" {
  autoscaling_group_name = aws_autoscaling_group.bastion_asg.name
  scheduled_action_name  = "Scale Down"
  recurrence             = var.scale_down_cron
  min_size               = var.scale_down_min_size
  max_size               = var.max_size
  desired_capacity       = var.scale_down_desired_capacity
}
