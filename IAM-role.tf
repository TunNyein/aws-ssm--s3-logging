#############################################################
# IAM Role for Session Manager
#############################################################

# IAM Role for EC2 instances to access Session Manager
resource "aws_iam_role" "session_manager_role" {
  name = "${var.frontend_prefix}-session-manager-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.frontend_prefix}-session-manager-role"
    environment = var.frontend_environment
  }
}

# Attach AWS managed policy for Session Manager
resource "aws_iam_role_policy_attachment" "session_manager_policy" {
  role       = aws_iam_role.session_manager_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach AWS managed policy for Session Manager
resource "aws_iam_role_policy_attachment" "session_manager_policy2" {
  role       = aws_iam_role.session_manager_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Instance profile for EC2 instances
resource "aws_iam_instance_profile" "session_manager_profile" {
  name = "${var.frontend_prefix}-session-manager-profile"
  role = aws_iam_role.session_manager_role.name

  tags = {
    Name        = "${var.frontend_prefix}-session-manager-profile"
    environment = var.frontend_environment
  }
}
