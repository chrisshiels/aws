output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnet_public_ids" {
  value = "${aws_subnet.public.*.id}"
}

output "subnet_app_ids" {
  value = "${aws_subnet.app.*.id}"
}

output "subnet_data_ids" {
  value = "${aws_subnet.app.*.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "eip_ids" {
  value = "${aws_eip.nat.*.id}"
}

output "nat_gateway_ids" {
  value = "${aws_nat_gateway.nat.*.id}"
}

output "route_table_public_id" {
  value = "${aws_route_table.public.id}"
}

output "route_table_app_ids" {
  value = "${aws_route_table.app.*.id}"
}

output "route_table_data_ids" {
  value = "${aws_route_table.data.*.id}"
}
