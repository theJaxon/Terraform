data "aws_availability_zones" "available" {}

module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  version                      = "3.14.4"
  name                         = "${var.namespace}-vpc"
  cidr                         = "10.0.0.0/16"
  azs                          = data.aws_availability_zones.available.names
  private_subnets              = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets               = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets             = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  tags = {
    module = "networking"
  }
}

resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    module = "networking"
  }
}

resource "aws_lb" "load_balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [for subnet in module.vpc.public_subnets : subnet]

  enable_deletion_protection = false

  tags = {
    module = "networking"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Allow Port 8080 inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Ingress 8080 from Load Balancer Security Group"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  tags = {
    module = "networking"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  description = "Allow Port 3306 inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Ingress 3306 from webserver Security Group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  tags = {
    module = "networking"
  }
}
