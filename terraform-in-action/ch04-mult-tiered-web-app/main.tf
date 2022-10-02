module "autoscaling" {
  source           = "./modules/autoscaling"
  namespace        = var.namespace
  vpc              = module.networking.vpc
  database_config  = module.database.database_config
  load_balancer_sg = module.networking.security_groups.load_balancer
  webserver_sg     = module.networking.security_groups.webserver
}

module "database" {
  source      = "./modules/database"
  namespace   = var.namespace
  vpc         = module.networking.vpc
  database_sg = module.networking.security_groups.database
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}
