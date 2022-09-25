module "autoscaling" {
  source    = "./modules/autoscaling"
  namespace = var.namespace
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
