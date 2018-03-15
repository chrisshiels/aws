output "sg_id" {
  value = "${module.securitygroup.sg_id}"
}

output "dbsng_id" {
  value = "${aws_db_subnet_group.dbsng.id}"
}

output "dbsng_arn" {
  value = "${aws_db_subnet_group.dbsng.arn}"
}

output "db_address" {
  value = "${aws_db_instance.db.address}"
}

output "db_arn" {
  value = "${aws_db_instance.db.arn}"
}

output "db_endpoint" {
  value = "${aws_db_instance.db.endpoint}"
}

output "db_hosted_zone_id" {
  value = "${aws_db_instance.db.hosted_zone_id}"
}

output "db_id" {
  value = "${aws_db_instance.db.id}"
}

output "db_resource_id" {
  value = "${aws_db_instance.db.resource_id}"
}

output "db_status" {
  value = "${aws_db_instance.db.status}"
}
