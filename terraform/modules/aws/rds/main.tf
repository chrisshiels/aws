resource "aws_security_group" "rds" {
  name = "${format("sg_%s_rds", replace(var.name, "-", "_"))}"
  description = "sg-${var.name}-rds"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sg-${var.name}-rds"
  }
}


resource "aws_security_group_rule" "rds-egress-allall-to-all" {
  security_group_id = "${aws_security_group.rds.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "rds-egress-allall-to-all"
}


resource "aws_security_group_rule" "rds-ingress-tcpport-from-all" {
  security_group_id = "${aws_security_group.rds.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = "${var.port}"
  to_port = "${var.port}"
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "rds-ingress-tcp${var.port}-from-all"
}


resource "aws_db_subnet_group" "rds" {
  name = "dbsg-${var.name}"
  description = "dbsg-${var.name}"
  subnet_ids = [ "${var.subnet_ids}" ]

  tags {
    Name = "dbsg-${var.name}"
  }
}


resource "aws_db_instance" "rds" {
  identifier = "rds-${var.name}"
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  license_model = "${var.license_model}"
  port = "${var.port}"
  publicly_accessible = false
  vpc_security_group_ids = [ "${aws_security_group.rds.id}" ]
  db_subnet_group_name = "${aws_db_subnet_group.rds.name}"
  multi_az = "${var.multi_az}"
  instance_class = "${var.instance_class}"
  allocated_storage = "${var.allocated_storage}"
  storage_type = "gp2"
  storage_encrypted = false
  username = "${var.username}"
  password = "${var.password}"
  name = "${var.schema_name}"
  backup_window = "${var.backup_window}"
  backup_retention_period = "${var.backup_retention_period}"
  allow_major_version_upgrade = false
  maintenance_window = "${var.maintenance_window}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  apply_immediately = "${var.apply_immediately}"
  copy_tags_to_snapshot = true
  skip_final_snapshot = "${var.skip_final_snapshot}"
  final_snapshot_identifier = "rds-${var.name}-final"
  iam_database_authentication_enabled = false

  tags {
    Name = "rds-${var.name}"
  }
}
