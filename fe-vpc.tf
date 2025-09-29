
resource "aws_vpc" "frontend_vpc" {

  cidr_block           = var.frontend_vpc_address_space
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.frontend_prefix}-vpc"
    environment = "${var.frontend_environment}"
  }
}

resource "aws_subnet" "frontend_private_subnet01" {
  vpc_id     = aws_vpc.frontend_vpc.id
  cidr_block = var.frontend_private_subnet_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.frontend_prefix}-private-subnet01-${var.region}"
  }
}



#############################################################
#  Private Route Tables
#############################################################

resource "aws_route_table" "frontend_private_rtb01" {
  vpc_id = aws_vpc.frontend_vpc.id


  tags = {
    Name = "${var.frontend_prefix}-private-rtb01"
  }
}

resource "aws_route_table_association" "frontend_private_subnet01_association" {
  subnet_id      = aws_subnet.frontend_private_subnet01.id
  route_table_id = aws_route_table.frontend_private_rtb01.id
}
