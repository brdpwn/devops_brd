module "ec2_nginx" {
  source             = "./modules/ec2_nginx"
  vpc_id             = var.vpc_id
  list_of_open_ports = var.list_of_open_ports
  instance_type      = var.instance_type
  name_prefix        = var.name_prefix
}

