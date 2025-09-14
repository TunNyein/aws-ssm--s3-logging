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

#############################################################
# Security Group for Session Manager
#############################################################

resource "aws_security_group" "session_manager_sg" {
  name        = "${var.frontend_prefix}-session-manager-sg"
  description = "Security group for Session Manager access"
  vpc_id      = aws_vpc.frontend_vpc.id


  tags = {
    Name        = "${var.frontend_prefix}-session-manager-sg"
    environment = var.frontend_environment
  }
}

# Egress rule for HTTPS traffic to VPC endpoints (Session Manager)
resource "aws_vpc_security_group_egress_rule" "session_manager_https_egress" {
  security_group_id            = aws_security_group.session_manager_sg.id
  # The recommended practice is least privilege: restrict outbound traffic to only the necessary destination IPs or endpoint security group for SSM connectivity.
  referenced_security_group_id = aws_security_group.vpc_endpoint_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "HTTPS outbound for Session Manager to VPC endpoints"

  tags = {
    Name        = "${var.frontend_prefix}-session-manager-https-egress"
    environment = var.frontend_environment
  }
}

resource "aws_security_group" "s3_sgp" {
  name        = "${var.frontend_prefix}-s3-bucket-sgp"
  description = "Security group for Session Manager access"
  vpc_id      = aws_vpc.frontend_vpc.id

  
  # Egress for S3 via prefix list
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [data.aws_prefix_list.s3.id]
    description     = "HTTPS outbound for S3 logging"
  }

  tags = {
    Name        = "${var.frontend_prefix}-s3-bucket-sgp"
    environment = var.frontend_environment
  }
}


#############################################################
# VPC Endpoints for Session Manager
#############################################################

# VPC Endpoint for SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.frontend_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.frontend_private_subnet01.id,
    # aws_subnet.frontend_private_subnet02.id,
    # aws_subnet.frontend_private_subnet03.id
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.frontend_prefix}-ssm-endpoint"
    environment = var.frontend_environment
  }
}

# VPC Endpoint for SSM Messages
resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = aws_vpc.frontend_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.frontend_private_subnet01.id,
    # aws_subnet.frontend_private_subnet02.id,
    # aws_subnet.frontend_private_subnet03.id
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.frontend_prefix}-ssm-messages-endpoint"
    environment = var.frontend_environment
  }
}

# VPC Endpoint for EC2 Messages
resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id            = aws_vpc.frontend_vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.frontend_private_subnet01.id,
    # aws_subnet.frontend_private_subnet02.id,
    # aws_subnet.frontend_private_subnet03.id
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.frontend_prefix}-ec2-messages-endpoint"
    environment = var.frontend_environment
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.frontend_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.frontend_private_rtb01.id,
    aws_route_table.frontend_private_rtb02.id,
    aws_route_table.frontend_private_rtb03.id
  ]

  tags = {
    Name        = "${var.frontend_prefix}-s3-endpoint"
    environment = var.frontend_environment
  }
}




# Security group for VPC Endpoints
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.frontend_prefix}-vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.frontend_vpc.id

  tags = {
    Name        = "${var.frontend_prefix}-vpc-endpoint-sg"
    environment = var.frontend_environment
  }
}

# Ingress rule for HTTPS traffic from VPC
resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_https_ingress" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  referenced_security_group_id = aws_security_group.session_manager_sg.id
  # cidr_ipv4         = var.frontend_vpc_address_space
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS from VPC for Session Manager"

  tags = {
    Name        = "${var.frontend_prefix}-vpc-endpoint-https-ingress"
    environment = var.frontend_environment
  }
}

# Egress rule for all outbound traffic (VPC endpoints need this for AWS service communication)
resource "aws_vpc_security_group_egress_rule" "vpc_endpoint_all_egress" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "All outbound traffic for VPC endpoint functionality"

  tags = {
    Name        = "${var.frontend_prefix}-vpc-endpoint-all-egress"
    environment = var.frontend_environment
  }
}

