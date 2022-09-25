output "database_config" {
  value = {
    db_username = aws_db_instance.database.username
    db_password = aws_db_instance.database.password
    db_name     = aws_db_instance.database.db_name
    db_hostname = aws_db_instance.database.address
    db_port     = aws_db_instance.database.port
  }
}
