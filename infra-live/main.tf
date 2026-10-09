module "vpc" {
  source = "../infra-module/vpc"
  name   = var.project_name
}

module "ec2_security_group" {
  source           = "../infra-module/ec2"
  name             = var.project_name
  vpc_id           = module.vpc.vpc_id
  ssh_allowed_cidr = var.ssh_allowed_cidr
}

module "rds" {
  source                = "../infra-module/rds"
  name                  = var.project_name
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ec2_security_group_id = module.ec2_security_group.security_group_id
  db_identifier         = var.db_identifier
  db_engine             = var.db_engine
  db_instance_class     = var.db_instance_class
  allocated_storage     = var.allocated_storage
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  skip_final_snapshot   = var.skip_final_snapshot
  deletion_protection   = var.deletion_protection
}

module "ec2_instance" {
  source            = "../infra-module/ec2-instance"
  name              = var.project_name
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  security_group_id = module.ec2_security_group.security_group_id
  key_name          = var.ec2_key_name
  instance_type     = var.ec2_instance_type
  public_key_path   = var.ssh_public_key_path
}