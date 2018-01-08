output "ami_id" {
  value = "${data.aws_ami.centos7.id}"
}
