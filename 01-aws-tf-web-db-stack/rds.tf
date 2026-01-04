# Generate Random Password for RDS Instance
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!@#%^*()_+-="
}

# Create secrets Manager Secret for RDS Password
resource "aws_secretsmanager_secret" "rds_password_secret" {
  name        = "${var.db_identifier}_credentials"
  description = "Credentials for RDS ${var.db_identifier}"
}

# Store the generated password in Secrets Manager as JSON string
resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id = aws_secretsmanager_secret.rds_password_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.rds_password.result
  })
}

# Create DB_SUBNET_GROUP for RDS Instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "rds_subnet_group"
  }
}

# Create an RDS MySQL Database in Private Subnet
resource "aws_db_instance" "rds_mysql_instance" {
  identifier             = var.db_identifier
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  allocated_storage      = 20
  storage_type           = "gp2"
  storage_encrypted      = true
  skip_final_snapshot    = true
  username               = jsondecode(aws_secretsmanager_secret_version.rds_password_version.secret_string)["username"]
  password               = jsondecode(aws_secretsmanager_secret_version.rds_password_version.secret_string)["password"]

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "rds_mysql_instance"
  }
}