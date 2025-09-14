
#############################################################
# Frontend Private Instance 01
#############################################################

resource "aws_instance" "frontend_private_instance01" {
  ami                  = data.aws_ami.fe_private_instance_ami.id
  instance_type        = var.fe_instance_type
  subnet_id            = aws_subnet.frontend_private_subnet01.id
  iam_instance_profile = aws_iam_instance_profile.session_manager_profile.name
  vpc_security_group_ids = [aws_security_group.session_manager_sg.id,aws_security_group.s3_sgp.id]

  tags = {
    Name        = "${var.frontend_prefix}-private-instance01"
    environment = "${var.frontend_environment}"
  }
}

#############################################################
# Frontend Private Instance 02
#############################################################

resource "aws_instance" "frontend_private_instance02" {
  ami                  = data.aws_ami.fe_private_instance_ami.id
  instance_type        = var.fe_instance_type
  subnet_id            = aws_subnet.frontend_private_subnet02.id
  iam_instance_profile = aws_iam_instance_profile.session_manager_profile.name
  vpc_security_group_ids = [aws_security_group.session_manager_sg.id,aws_security_group.s3_sgp.id]

  tags = {
    Name        = "${var.frontend_prefix}-private-instance02"
    environment = "${var.frontend_environment}"
  }
}

#############################################################
# Frontend Private Instance 03
#############################################################

resource "aws_instance" "frontend_private_instance03" {
  ami                  = data.aws_ami.fe_private_instance_ami.id
  instance_type        = var.fe_instance_type
  subnet_id            = aws_subnet.frontend_private_subnet03.id
  iam_instance_profile = aws_iam_instance_profile.session_manager_profile.name
  vpc_security_group_ids = [aws_security_group.session_manager_sg.id,aws_security_group.s3_sgp.id]

  tags = {
    Name        = "${var.frontend_prefix}-private-instance03"
    environment = "${var.frontend_environment}"
  }
}
