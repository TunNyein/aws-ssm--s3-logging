#############################################################
# VPC Endpoints for Session Manager
#############################################################

# VPC Endpoint for SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.frontend_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.frontend_private_subnet01.id
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
    aws_subnet.frontend_private_subnet01.id
    
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
    aws_subnet.frontend_private_subnet01.id
   
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
    aws_route_table.frontend_private_rtb01.id
    
  ]

  tags = {
    Name        = "${var.frontend_prefix}-s3-endpoint"
    environment = var.frontend_environment
  }
}


