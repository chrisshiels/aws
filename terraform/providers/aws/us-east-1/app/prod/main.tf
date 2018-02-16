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


module "app" {
  source = "../../../../../stacks/aws/app"
  env = "prod"
  key_name = "aws"
  vpc_availability_zones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  vpc_public_subnet_cidrs = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  vpc_app_subnet_cidrs = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
  vpc_data_subnet_cidrs = [ "10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24" ]
  asg_instance_type = "t2.micro"
  asg_min_size = 5
  asg_max_size = 5
  asg_desired_capacity = 5
  rds_multi_az = true
  rds_instance_class = "db.t2.micro"
  rds_allocated_storage = 5
  rds_backup_window = "01:00-03:00"
  rds_backup_retention_period = 7
  rds_maintenance_window = "mon:04:00-mon:06:00"
}
