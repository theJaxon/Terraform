output "database_config" {
  value = {
    username = aws_db_instance.database.username
    password = aws_db_instance.database.password
    database = aws_db_instance.database.db_name
    address  = aws_db_instance.database.address
    port     = aws_db_instance.database.port
  }
}
