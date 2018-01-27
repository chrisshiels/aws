output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnet_public_ids" {
  value = "${aws_subnet.public.*.id}"
}

output "subnet_private_ids" {
  value = "${aws_subnet.private.*.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "nat_gateway_ids" {
  value = "${aws_nat_gateway.nat.*.id}"
}
