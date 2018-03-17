output "sg_id" {
  value = "${module.securitygroup.sg_id}"
}

output "instance_ids" {
  value = "${aws_instance.instance.*.id}"
}

output "instance_public_dns" {
  value = "${aws_instance.instance.*.public_dns}"
}

output "instance_public_ips" {
  value = "${aws_instance.instance.*.public_ip}"
}

output "instance_private_dns" {
  value = "${aws_instance.instance.*.private_dns}"
}

output "instance_private_ips" {
  value = "${aws_instance.instance.*.private_ip}"
}
