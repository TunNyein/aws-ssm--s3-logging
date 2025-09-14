
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

resource "aws_subnet" "frontend_private_subnet02" {
  vpc_id     = aws_vpc.frontend_vpc.id
  cidr_block = var.frontend_private_subnet_cidr[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.frontend_prefix}-private-subnet02-${var.region}"
  }
}

resource "aws_subnet" "frontend_private_subnet03" {
  vpc_id     = aws_vpc.frontend_vpc.id
  cidr_block = var.frontend_private_subnet_cidr[2]
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.frontend_prefix}-private-subnet03-${var.region}"
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

resource "aws_route_table" "frontend_private_rtb02" {
  vpc_id = aws_vpc.frontend_vpc.id


  tags = {
    Name = "${var.frontend_prefix}-private-rtb02"
  }
}

resource "aws_route_table_association" "frontend_private_subnet02_association" {
  subnet_id      = aws_subnet.frontend_private_subnet02.id
  route_table_id = aws_route_table.frontend_private_rtb02.id
}

resource "aws_route_table" "frontend_private_rtb03" {
  vpc_id = aws_vpc.frontend_vpc.id


  tags = {
    Name = "${var.frontend_prefix}-private-rtb03"
  }
}

resource "aws_route_table_association" "frontend_private_subnet03_association" {
  subnet_id      = aws_subnet.frontend_private_subnet03.id
  route_table_id = aws_route_table.frontend_private_rtb03.id
}
