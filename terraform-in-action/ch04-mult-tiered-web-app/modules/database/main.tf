resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@/'\""
}

# RDS Instance
resource "aws_db_instance" "database" {
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  identifier             = "${var.namespace}-db-instance"
  db_name                = "pets-db"
  username               = "admin"
  password               = random_password.password.result
  db_subnet_group_name   = var.vpc.database_subnet_group
  vpc_security_group_ids = [var.database_sg]
  skip_final_snapshot    = true
  allocated_storage      = 10
}
