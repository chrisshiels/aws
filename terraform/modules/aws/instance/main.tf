module "securitygroup" {
  source = "../../../modules/aws/securitygroup"
  name = "${var.name}"
  vpc_id = "${var.vpc_id}"
  security_group_allow_cidrs_len = "${var.security_group_allow_cidrs_len}"
  security_group_allow_cidrs = "${var.security_group_allow_cidrs}"
  security_group_allow_ids_len = "${var.security_group_allow_ids_len}"
  security_group_allow_ids = "${var.security_group_allow_ids}"
}


resource "aws_instance" "instance" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = [
    "${var.security_group_ids}",
    "${module.securitygroup.security_group_id}"
  ]
  subnet_id = "${var.subnet_public_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name = "${var.key_name}"
  monitoring = false
  user_data = "${var.user_data}"
  iam_instance_profile = "${var.instance_profile_id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_block_device_volume_size}"
    delete_on_termination = true
  }

  tags {
    Name = "${var.name}"
    TerraformDependsOn = "${var.internet_gateway_id}"
  }

  volume_tags {
    Name = "${var.name}"
  }
}
