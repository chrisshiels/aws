resource "aws_security_group" "securitygroup" {
  name = "${format("sg_%s", replace(var.name, "-", "_"))}"
  description = "sg-${var.name}"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.tags,
                  map("Name", "sg-${var.name}"))}"
}


resource "aws_security_group_rule" "securitygroup-egress-allall-to-all" {
  security_group_id = "${aws_security_group.securitygroup.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "securitygroup-egress-allall-to-all"
}


resource "aws_security_group_rule" "instance-ingress-from-cidrs" {
  count = "${var.sg_allow_cidrs_len}"
  security_group_id = "${aws_security_group.securitygroup.id}"
  type = "ingress"
  protocol =
    "${element(split(":", element(var.sg_allow_cidrs, count.index)),
               0)}"
  from_port =
    "${element(split(":", element(var.sg_allow_cidrs, count.index)),
               1)}"
  to_port =
    "${element(split(":", element(var.sg_allow_cidrs, count.index)),
               1)}"
  cidr_blocks = [
    "${element(split(":", element(var.sg_allow_cidrs, count.index)),
               2)}"
  ]
  #description =
  #  "${element(split(":", element(var.sg_allow_cidrs, count.index)),
  #             3)}"
}


resource "aws_security_group_rule" "instance-ingress-from-ids" {
  count = "${var.sg_allow_ids_len}"
  security_group_id = "${aws_security_group.securitygroup.id}"
  type = "ingress"
  protocol =
    "${element(split(":", element(var.sg_allow_ids, count.index)),
               0)}"
  from_port =
    "${element(split(":", element(var.sg_allow_ids, count.index)),
               1)}"
  to_port =
    "${element(split(":", element(var.sg_allow_ids, count.index)),
               1)}"
  source_security_group_id =
    "${element(split(":", element(var.sg_allow_ids, count.index)),
               2)}"
  #description =
  #  "${element(split(":", element(var.sg_allow_ids, count.index)),
  #             3)}"
}
