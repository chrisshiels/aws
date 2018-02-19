terraform {
  required_version = "= 0.11.3"
}


provider "aws" {
  version = "1.8"

  region = "eu-west-1"
}


provider "template" {
  version = "1.0"
}


module "elbasgrds" {
  source = "../../../../../stacks/aws/elbasgrds"
  env = "dev"
  key_name = "aws"
  vpc_cidr = "10.0.0.0/16"
  vpc_availability_zones = [ "eu-west-1a", "eu-west-1b" ]
  vpc_subnet_public_cidrs = [ "10.0.1.0/24", "10.0.2.0/24" ]
  vpc_subnet_app_cidrs = [ "10.0.4.0/24", "10.0.5.0/24" ]
  vpc_subnet_data_cidrs = [ "10.0.7.0/24", "10.0.8.0/24" ]
  asg_instance_type = "t2.micro"
  asg_min_size = 2
  asg_max_size = 2
  asg_desired_capacity = 2
  rds_multi_az = false
  rds_instance_class = "db.t2.micro"
  rds_allocated_storage = 5
  rds_backup_window = "01:00-03:00"
  rds_backup_retention_period = 7
  rds_maintenance_window = "mon:04:00-mon:06:00"
}
