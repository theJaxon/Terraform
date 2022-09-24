output "vpc" {
  value = module.vpc
}

output "security_groups" {
  value = {
    load_balancer = aws_security_group.load_balancer_sg.id
    webserver     = aws_security_group.webserver_sg.id
    database      = aws_security_group.database_sg.id
  }
}
