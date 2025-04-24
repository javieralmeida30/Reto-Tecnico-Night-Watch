resource "aws_instance" "public_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.grafana_profile.name
  vpc_security_group_ids = [var.public_sg_id]
  associate_public_ip_address = true

  user_data = file("${path.root}/scripts/grafana_user_data.sh")

  tags = {
    Name = "public-bastion-grafana"
  }
}

resource "aws_instance" "private_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  associate_public_ip_address = false

user_data = file("${path.root}/scripts/postgres_user_data.sh")

  tags = {
    Name = "private-db-postgres"
  }
}
