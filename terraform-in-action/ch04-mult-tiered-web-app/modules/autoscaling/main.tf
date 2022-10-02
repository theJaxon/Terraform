data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/user-data/cloud_config.yaml", var.database_config)
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_iam_role" "iam_role" {
  name               = "ec2-assume-role"
  assume_role_policy = file("${path.module}/policy/ec2-assume-role-policy.json")
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "rds:*",
      "logs:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam-instance-profile"
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name   = "iam-role-policy"
  role   = aws_iam_role.iam_role.name
  policy = data.aws_iam_policy_document.iam_policy_document.json
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "8.1.0"
  name               = "${var.namespace}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc.vpc_id
  subnets            = var.vpc.public_subnets
  security_groups    = [var.load_balancer_sg]
  http_tcp_listeners = [{
    port               = 80,
    protocol           = "HTTP",
    target_group_index = 0
  }]

  target_groups = [{
    backend_protocol = "HTTP",
    backend_port     = 8080
    target_type      = "instance"
  }]
}

resource "aws_launch_template" "webserver_launch_template" {
  image_id      = data.aws_ami.ubuntu.image_id
  name_prefix   = var.namespace
  instance_type = "t2.micro"
  user_data     = data.cloudinit_config.config.rendered
  # key_name      = var.ssh_key
  iam_instance_profile {
    arn = aws_iam_instance_profile.iam_instance_profile.arn

  }
  vpc_security_group_ids = [var.webserver_sg]
}

resource "aws_autoscaling_group" "webserver_asg" {
  name                = "${var.namespace}-asg"
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns   = module.alb.target_group_arns
  launch_template {
    id      = aws_launch_template.webserver_launch_template.id
    version = aws_launch_template.webserver_launch_template.latest_version
  }
}
