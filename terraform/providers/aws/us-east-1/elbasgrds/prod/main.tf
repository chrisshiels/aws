terraform {
  required_version = "= 0.11.3"
}


provider "aws" {
  version = "1.8"

  region = "us-east-1"
}


provider "template" {
  version = "1.0"
}


module "elbasgrds" {
  source = "../../../../../stacks/aws/elbasgrds"
  env = "prod"
  key_name = "aws"
  vpc_cidr = "10.0.0.0/16"
  vpc_availability_zones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  vpc_subnet_public_cidrs = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  vpc_subnet_app_cidrs = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
  vpc_subnet_data_cidrs = [ "10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24" ]
  bastion_instance_type = "t2.micro"
  bastion_ssh_cidrs = [ "0.0.0.0/0" ]
  elb_http_cidrs = [ "0.0.0.0/0" ]
  asglc_instance_type = "t2.micro"
  asg_min_size = 5
  asg_max_size = 5
  asg_desired_capacity = 5
  db_multi_az = true
  db_instance_class = "db.t2.micro"
  db_allocated_storage = 5
  db_backup_window = "01:00-03:00"
  db_backup_retention_period = 7
  db_maintenance_window = "mon:04:00-mon:06:00"
}
