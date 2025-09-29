#############################################################
# Outputs for Session Manager Resources
#############################################################

output "instance_ids" {
  description = "Instance IDs for Session Manager access"
  value = {
    instance01 = aws_instance.frontend_private_instance01.id
    
  }
}


output "session_manager_commands" {
  description = "AWS CLI commands to connect to instances via Session Manager"
  # Install SessionManager Plugin
  # https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-macos-overview.html
  value = {
    instance01 = "aws ssm start-session --target ${aws_instance.frontend_private_instance01.id}"
  
  }
}
