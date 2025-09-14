#############################################################
# Outputs for Session Manager Resources
#############################################################

output "instance_ids" {
  description = "Instance IDs for Session Manager access"
  value = {
    instance01 = aws_instance.frontend_private_instance01.id
    instance02 = aws_instance.frontend_private_instance02.id
    instance03 = aws_instance.frontend_private_instance03.id
  }
}

output "session_manager_role_arn" {
  description = "ARN of the Session Manager IAM role"
  value = aws_iam_role.session_manager_role.arn
}

output "vpc_endpoints" {
  description = "VPC Endpoints for Session Manager"
  value = {
    ssm         = aws_vpc_endpoint.ssm.id
    ssm_messages = aws_vpc_endpoint.ssm_messages.id
    ec2_messages = aws_vpc_endpoint.ec2_messages.id
  }
}

output "session_manager_commands" {
  description = "AWS CLI commands to connect to instances via Session Manager"
  # Install SessionManager Plugin
  # https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-macos-overview.html
  value = {
    instance01 = "aws ssm start-session --target ${aws_instance.frontend_private_instance01.id}"
    instance02 = "aws ssm start-session --target ${aws_instance.frontend_private_instance02.id}"
    instance03 = "aws ssm start-session --target ${aws_instance.frontend_private_instance03.id}"
  }
}
