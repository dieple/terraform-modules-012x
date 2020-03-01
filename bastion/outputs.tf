output "asg_id" {
  value = aws_autoscaling_group.bastion_asg.id
}

output "asg_arn" {
  value = aws_autoscaling_group.bastion_asg.arn
}

output "aws_security_group_allow_ssh_id" {
  value = aws_security_group.allow_ssh_sg.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.bastion_asg.name
}

output "ssh_user" {
  value       = var.ssh_user
  description = "SSH user"
}

output "security_group_id" {
  value       = aws_security_group.allow_ssh_sg.id
  description = "Security group ID"
}

output "role" {
  value       = aws_iam_role.bastion_role.name
  description = "Name of AWS IAM Role associated with the instance"
}

output "public_ip" {
  value       = aws_eip.bastion.public_ip
  description = "Public IP of the instance (or EIP)"
}

output "private_ip" {
  value       = aws_eip.bastion.private_ip
  description = "Private IP of the instance"
}
