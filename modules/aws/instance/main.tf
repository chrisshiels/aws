module "securitygroup" {
  source = "../../../modules/aws/securitygroup"
  name = "${var.name}"
  vpc_id = "${var.vpc_id}"
  sg_allow_cidrs_len = "${var.sg_allow_cidrs_len}"
  sg_allow_cidrs = "${var.sg_allow_cidrs}"
  sg_allow_ids_len = "${var.sg_allow_ids_len}"
  sg_allow_ids = "${var.sg_allow_ids}"
}


resource "aws_instance" "instance" {
  count = "${var.count}"
  ami = "${var.instance_ami_id}"
  instance_type = "${var.instance_instance_type}"
  vpc_security_group_ids = [
    "${var.instance_security_group_ids}",
    "${module.securitygroup.sg_id}"
  ]
  subnet_id = "${var.instance_subnet_id}"
  associate_public_ip_address = "${var.instance_associate_public_ip_address}"
  key_name = "${var.instance_key_name}"
  monitoring = false
  user_data = "${var.instance_user_data}"
  iam_instance_profile = "${var.instance_instance_profile_id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.instance_root_block_device_volume_size}"
    delete_on_termination = true
  }

  tags {
    Name = "${var.name}${count.index + 1}"
    TerraformDependsOn = "${var.instance_internet_gateway_id}"
  }

  volume_tags {
    Name = "${var.name}${count.index + 1}"
  }
}
