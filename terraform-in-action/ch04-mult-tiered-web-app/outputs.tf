output "db_password" {
  value     = module.database.database_config.db_password
  sensitive = true
}

output "lb_dns_name" {
  value = ""
}
