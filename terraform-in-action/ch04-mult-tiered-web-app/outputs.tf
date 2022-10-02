output "db_password" {
  value     = module.database.database_config.password
  sensitive = true
}

output "lb_dns_name" {
  value = module.autoscaling.lb_dns_name
}
