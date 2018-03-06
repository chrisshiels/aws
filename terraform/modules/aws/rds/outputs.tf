output "sg_id" {
  value = "${module.securitygroup.security_group_id}"
}

output "db_subnet_group_id" {
  value = "${aws_db_subnet_group.rds.id}"
}

output "db_subnet_group_arn" {
  value = "${aws_db_subnet_group.rds.arn}"
}

output "db_instance_address" {
  value = "${aws_db_instance.rds.address}"
}

output "db_instance_arn" {
  value = "${aws_db_instance.rds.arn}"
}

output "db_instance_endpoint" {
  value = "${aws_db_instance.rds.endpoint}"
}

output "db_instance_hosted_zone_id" {
  value = "${aws_db_instance.rds.hosted_zone_id}"
}

output "db_instance_id" {
  value = "${aws_db_instance.rds.id}"
}

output "db_instance_resource_id" {
  value = "${aws_db_instance.rds.resource_id}"
}

output "db_instance_status" {
  value = "${aws_db_instance.rds.status}"
}
