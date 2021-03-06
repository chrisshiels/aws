module "vpc" {
  source = "../../../modules/aws/vpc"
  name = "elbasgrds-${var.env}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_availability_zones = "${var.vpc_availability_zones}"
  vpc_subnet_public_cidrs = "${var.vpc_subnet_public_cidrs}"
  vpc_subnet_app_cidrs = "${var.vpc_subnet_app_cidrs}"
  vpc_subnet_data_cidrs = "${var.vpc_subnet_data_cidrs}"
  tags = "${var.tags}"
}


module "securitygroup-all" {
  source = "../../../modules/aws/securitygroup"
  name = "elbasgrds-${var.env}-all"
  vpc_id = "${module.vpc.vpc_id}"
  tags = "${var.tags}"
}


data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name = "name"
    values = [ "CentOS Linux 7 x86_64 HVM EBS*" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

  owners = [ "679593333241" ]
}


data "aws_iam_policy_document" "policy" {
  statement {
    actions = [ "ec2:DescribeTags" ]

    # Note:
    # As of December 2017 it doesn't look to be possible to limit this to
    # return information for the calling instance only.
    resources = [ "*" ]
  }
}


module "instanceprofile" {
  source = "../../../modules/aws/instanceprofile"
  name = "elbasgrds-${var.env}-instance"
  policy = "${data.aws_iam_policy_document.policy.json}"
  tags = "${var.tags}"
}


data "template_file" "user-data" {
  template = "${file(format("%s/files/user-data.tpl", path.module))}"

  vars {
  }
}


module "bastion" {
  source = "../../../modules/aws/instance"
  name = "elbasgrds-${var.env}-bastion"
  count = 1
  vpc_id = "${module.vpc.vpc_id}"
  instance_subnet_ids = "${module.vpc.sn_public_ids}"
  instance_internet_gateway_id = "${module.vpc.igw_id}"
  instance_instance_profile_id = "${module.instanceprofile.instanceprofile_id}"
  instance_ami_id = "${data.aws_ami.centos7.id}"
  instance_user_data = "${data.template_file.user-data.rendered}"
  instance_key_name = "${var.key_name}"
  instance_instance_type = "${var.bastion_instance_type}"
  instance_associate_public_ip_address = true
  instance_root_block_device_volume_size = 8
  instance_security_group_ids = [
    "${module.securitygroup-all.sg_id}"
  ]
  sg_allow_cidrs_len = 1
  sg_allow_cidrs = [
    "${formatlist("tcp:22:%s", var.bastion_ssh_cidrs)}"
  ]
  tags = "${var.tags}"
}


module "elbasg" {
  source = "../../../modules/aws/elbasg"
  name = "elbasgrds-${var.env}-app"
  vpc_id = "${module.vpc.vpc_id}"
  elb_internal = false
  elb_subnet_ids = "${module.vpc.sn_public_ids}"
  elb_loadbalancer_protocol = "http"
  elb_loadbalancer_port = 80
  elb_server_protocol = "http"
  elb_server_port = 80
  elb_health_check_target = "HTTP:80/"
  elb_security_group_ids = [ "${module.securitygroup-all.sg_id}" ]
  elb_sg_allow_cidrs_len = 1
  elb_sg_allow_cidrs = [
    "${formatlist("tcp:80:%s", var.elb_http_cidrs)}"
  ]
  asglc_instance_profile_id = "${module.instanceprofile.instanceprofile_id}"
  asglc_ami_id = "${data.aws_ami.centos7.id}"
  asglc_user_data = "${data.template_file.user-data.rendered}"
  asglc_key_name = "${var.key_name}"
  asglc_instance_type = "${var.asglc_instance_type}"
  asglc_security_group_ids = [ "${module.securitygroup-all.sg_id}" ]
  asglc_sg_allow_ids_len = 2
  asglc_sg_allow_ids = [
    "tcp:22:${module.bastion.sg_id}",
    "tcp:80:${module.bastion.sg_id}"
  ]
  asg_subnet_ids = "${module.vpc.sn_app_ids}"
  asg_nat_gateway_ids = "${module.vpc.nat_ids}"
  asg_min_size = "${var.asg_min_size}"
  asg_max_size = "${var.asg_max_size}"
  asg_desired_capacity = "${var.asg_desired_capacity}"
  tags = "${var.tags}"
}


module "rds" {
  source = "../../../modules/aws/rds"
  name = "elbasgrds-${var.env}-app"
  vpc_id = "${module.vpc.vpc_id}"
  dbsng_subnet_ids = "${module.vpc.sn_data_ids}"
  db_engine = "mysql"
  db_engine_version = "5.7.19"
  db_license_model = "general-public-license"
  db_port = 3306
  db_option_group_name = "default:mysql-5-7"
  db_parameter_group_name = "default.mysql5.7"
  db_multi_az = "${var.db_multi_az}"
  db_instance_class = "${var.db_instance_class}"
  db_allocated_storage = "${var.db_allocated_storage}"
  db_username = "${var.db_username}"
  db_password = "${var.db_password}"
  db_schema_name = "db"
  db_backup_window = "${var.db_backup_window}"
  db_backup_retention_period = "${var.db_backup_retention_period}"
  db_maintenance_window = "${var.db_maintenance_window}"
  db_auto_minor_version_upgrade = false
  db_apply_immediately = false
  db_skip_final_snapshot = true
  db_security_group_ids = [ "${module.securitygroup-all.sg_id}" ]
  sg_allow_ids_len = 1
  sg_allow_ids = [
    "tcp:3306:${module.elbasg.asglc_sg_id}"
  ]
  tags = "${var.tags}"
}


resource "aws_route53_zone" "zone" {
  name = "${var.r53_domain}"
  vpc_id = "${module.vpc.vpc_id}"
  force_destroy = false
  comment = "${var.r53_domain}"

  tags = "${merge(var.tags,
                  map("Name", var.r53_domain))}"
}


module "route53record" {
  source = "../../../modules/aws/route53record"
  name = "${var.r53_domain}"
  r53_zone_id = "${aws_route53_zone.zone.zone_id}"
  r53_records_len = 3
  r53_records = [
    "bastion:60:CNAME:${module.bastion.instance_public_dns[0]}",
    "elb:60:CNAME:${module.elbasg.elb_dns_name}",
    "db:60:CNAME:${module.rds.db_endpoint}"
  ]
  tags = "${var.tags}"
}
