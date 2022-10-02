variable "namespace" {}

variable "vpc" {}

variable "load_balancer_sg" {}

variable "webserver_sg" {}

variable "database_config" {
  type = object({
    username = string
    password = string
    database = string
    address  = string
    port     = string
  })
}
