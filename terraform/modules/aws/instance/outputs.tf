output "security_group_id" {
  value = "${module.securitygroup.security_group_id}"
}

output "instance_id" {
  value = "${aws_instance.instance.id}"
}

output "instance_public_dns" {
  value = "${aws_instance.instance.public_dns}"
}

output "instance_public_ip" {
  value = "${aws_instance.instance.public_ip}"
}

output "instance_private_dns" {
  value = "${aws_instance.instance.private_dns}"
}

output "instance_private_ip" {
  value = "${aws_instance.instance.private_ip}"
}
