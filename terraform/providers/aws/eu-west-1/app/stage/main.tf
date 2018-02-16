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


module "app" {
  source = "../../../../../stacks/aws/app"
  env = "stage"
  availabilityzones = [ "eu-west-1a", "eu-west-1b" ]
  publicsubnetcidrs = [ "10.0.1.0/24", "10.0.2.0/24" ]
  appsubnetcidrs = [ "10.0.4.0/24", "10.0.5.0/24" ]
  datasubnetcidrs = [ "10.0.7.0/24", "10.0.8.0/24" ]
  key_name = "aws"
  min_size = 2
  max_size = 2
  desired_capacity = 2
  rds_multi_az = false
  rds_instance_class = "db.t2.micro"
  rds_allocated_storage = 5
  rds_backup_window = "01:00-03:00"
  rds_backup_retention_period = 7
  rds_maintenance_window = "mon:04:00-mon:06:00"
}
