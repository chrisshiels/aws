module "securitygroup" {
  source = "../../../modules/aws/securitygroup"
  name = "${var.name}-db"
  vpc_id = "${var.vpc_id}"
  sg_allow_cidrs_len = "${var.sg_allow_cidrs_len}"
  sg_allow_cidrs = [ "${var.sg_allow_cidrs}" ]
  sg_allow_ids_len = "${var.sg_allow_ids_len}"
  sg_allow_ids = [ "${var.sg_allow_ids}" ]
  tags = "${var.tags}"
}


resource "aws_db_subnet_group" "dbsng" {
  name = "dbsng-${var.name}"
  description = "dbsng-${var.name}"
  subnet_ids = [ "${var.dbsng_subnet_ids}" ]

  tags = "${merge(var.tags,
                  map("Name", "dbsng-${var.name}"))}"
}


resource "aws_db_instance" "db" {
  identifier = "db-${var.name}"
  engine = "${var.db_engine}"
  engine_version = "${var.db_engine_version}"
  license_model = "${var.db_license_model}"
  port = "${var.db_port}"
  publicly_accessible = false
  vpc_security_group_ids = [
    "${var.db_security_group_ids}",
    "${module.securitygroup.sg_id}"
  ]
  db_subnet_group_name = "${aws_db_subnet_group.dbsng.name}"
  option_group_name = "${var.db_option_group_name}"
  parameter_group_name = "${var.db_parameter_group_name}"
  multi_az = "${var.db_multi_az}"
  instance_class = "${var.db_instance_class}"
  allocated_storage = "${var.db_allocated_storage}"
  storage_type = "gp2"
  storage_encrypted = false
  username = "${var.db_username}"
  password = "${var.db_password}"
  name = "${var.db_schema_name}"
  backup_window = "${var.db_backup_window}"
  backup_retention_period = "${var.db_backup_retention_period}"
  allow_major_version_upgrade = false
  maintenance_window = "${var.db_maintenance_window}"
  auto_minor_version_upgrade = "${var.db_auto_minor_version_upgrade}"
  apply_immediately = "${var.db_apply_immediately}"
  copy_tags_to_snapshot = true
  skip_final_snapshot = "${var.db_skip_final_snapshot}"
  final_snapshot_identifier = "db-${var.name}-final"
  iam_database_authentication_enabled = false

  tags = "${merge(var.tags,
                  map("Name", "db-${var.name}"))}"
}
