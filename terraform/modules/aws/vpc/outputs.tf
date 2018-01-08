output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnet_public_id" {
  value = "${aws_subnet.public.id}"
}

output "subnet_private_id" {
  value = "${aws_subnet.private.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.igw.id}"
}
