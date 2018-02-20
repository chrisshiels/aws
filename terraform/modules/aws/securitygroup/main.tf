resource "aws_security_group" "securitygroup" {
  name = "${format("sg_%s", replace(var.name, "-", "_"))}"
  description = "sg-${var.name}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sg-${var.name}"
  }
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


resource "aws_security_group_rule" "securitygroup-ingress-tcp-from-cidrs" {
  count = "${length(var.security_group_ports_tcp) * length(var.security_group_cidrs)}"
  security_group_id = "${aws_security_group.securitygroup.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = "${element(var.security_group_ports_tcp, count.index / length(var.security_group_ports_tcp))}"
  to_port = "${element(var.security_group_ports_tcp, count.index / length(var.security_group_ports_tcp))}"
  cidr_blocks = [ "${element(var.security_group_cidrs, count.index % length(var.security_group_ports_tcp))}" ]
  description = "securitygroup-ingress-tcp-from-cidrs"
}


resource "aws_security_group_rule" "securitygroup-ingress-tcp-from-ids" {
  count = "${length(var.security_group_ports_tcp) * length(var.security_group_ids)}"
  security_group_id = "${aws_security_group.securitygroup.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = "${element(var.security_group_ports_tcp, count.index / length(var.security_group_ports_tcp))}"
  to_port = "${element(var.security_group_ports_tcp, count.index / length(var.security_group_ports_tcp))}"
  source_security_group_id = "${element(var.security_group_ids, count.index % length(var.security_group_ports_tcp))}"
  description = "securitygroup-ingress-tcp-from-ids"
}


resource "aws_security_group_rule" "securitygroup-ingress-udp-from-cidrs" {
  count = "${length(var.security_group_ports_udp) * length(var.security_group_cidrs)}"
  security_group_id = "${aws_security_group.securitygroup.id}"
  type = "ingress"
  protocol = "udp"
  from_port = "${element(var.security_group_ports_udp, count.index / length(var.security_group_ports_udp))}"
  to_port = "${element(var.security_group_ports_udp, count.index / length(var.security_group_ports_udp))}"
  cidr_blocks = [ "${element(var.security_group_cidrs, count.index % length(var.security_group_ports_udp))}" ]
  description = "securitygroup-ingress-udp-from-cidrs"
}


resource "aws_security_group_rule" "securitygroup-ingress-udp-from-ids" {
  count = "${length(var.security_group_ports_udp) * length(var.security_group_ids)}"
  security_group_id = "${aws_security_group.securitygroup.id}"
  type = "ingress"
  protocol = "udp"
  from_port = "${element(var.security_group_ports_udp, count.index / length(var.security_group_ports_udp))}"
  to_port = "${element(var.security_group_ports_udp, count.index / length(var.security_group_ports_udp))}"
  source_security_group_id = "${element(var.security_group_ids, count.index % length(var.security_group_ports_udp))}"
  description = "securitygroup-ingress-udp-from-ids"
}
