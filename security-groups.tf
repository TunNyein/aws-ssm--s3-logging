
#############################################################
# Security Group for Session Manager
#############################################################

# Security Group for EC2

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
