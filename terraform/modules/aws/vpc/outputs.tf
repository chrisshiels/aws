output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "sn_public_ids" {
  value = "${aws_subnet.sn-public.*.id}"
}

output "sn_app_ids" {
  value = "${aws_subnet.sn-app.*.id}"
}

output "sn_data_ids" {
  value = "${aws_subnet.sn-data.*.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "eip_ids" {
  value = "${aws_eip.eip.*.id}"
}

output "nat_ids" {
  value = "${aws_nat_gateway.nat.*.id}"
}

output "rtb_public_id" {
  value = "${aws_route_table.rtb-public.id}"
}

output "rtb_app_ids" {
  value = "${aws_route_table.rtb-app.*.id}"
}

output "rtb_data_ids" {
  value = "${aws_route_table.rtb-data.*.id}"
}
