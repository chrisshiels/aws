resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = "${merge(var.tags,
                  map("Name", "vpc-${var.name}"))}"
}


resource "aws_subnet" "sn-public" {
  count = "${length(var.vpc_subnet_public_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.vpc_availability_zones, count.index)}"
  cidr_block = "${element(var.vpc_subnet_public_cidrs, count.index)}"
  map_public_ip_on_launch = true

  tags = "${merge(var.tags,
                  map("Name", "sn-${var.name}-public-${substr(element(var.vpc_availability_zones, count.index), -2, -1)}"))}"
}


resource "aws_subnet" "sn-app" {
  count = "${length(var.vpc_subnet_app_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.vpc_availability_zones, count.index)}"
  cidr_block = "${element(var.vpc_subnet_app_cidrs, count.index)}"
  map_public_ip_on_launch = false

  tags = "${merge(var.tags,
                  map("Name", "sn-${var.name}-app-${substr(element(var.vpc_availability_zones, count.index), -2, -1)}"))}"
}


resource "aws_subnet" "sn-data" {
  count = "${length(var.vpc_subnet_data_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.vpc_availability_zones, count.index)}"
  cidr_block = "${element(var.vpc_subnet_data_cidrs, count.index)}"
  map_public_ip_on_launch = false

  tags = "${merge(var.tags,
                  map("Name", "sn-${var.name}-data-${substr(element(var.vpc_availability_zones, count.index), -2, -1)}"))}"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.tags,
                  map("Name", "igw-${var.name}"))}"
}


resource "aws_eip" "eip" {
  count = "${length(var.vpc_subnet_public_cidrs)}"
  vpc = true
  depends_on = [ "aws_internet_gateway.igw" ]

  tags = "${merge(var.tags,
                  map("Name", "eip-${var.name}-natgw-${substr(element(var.vpc_availability_zones, count.index), -2, -1)}"))}"
}


resource "aws_nat_gateway" "nat" {
  count = "${length(var.vpc_subnet_public_cidrs)}"
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.sn-public.*.id, count.index)}"

  tags = "${merge(var.tags,
                  map("Name", "nat-${var.name}-${substr(element(var.vpc_availability_zones, count.index), -2, -1)}"))}"

  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_route_table" "rtb-public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.tags,
                  map("Name", "rtb-${var.name}-public"))}"
}


resource "aws_route" "public-default" {
  route_table_id = "${aws_route_table.rtb-public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}


resource "aws_route_table_association" "public-public" {
  count = "${length(var.vpc_subnet_public_cidrs)}"
  subnet_id = "${element(aws_subnet.sn-public.*.id, count.index)}"
  route_table_id = "${aws_route_table.rtb-public.id}"
}


resource "aws_route_table" "rtb-app" {
  count = "${length(var.vpc_subnet_app_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.tags,
                  map("Name", "rtb-${var.name}-app-${substr(element(var.vpc_availability_zones, count.index), -2, -1)}"))}"
}


resource "aws_route" "app-default" {
  count = "${length(var.vpc_subnet_app_cidrs)}"
  route_table_id = "${element(aws_route_table.rtb-app.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}


resource "aws_route_table_association" "app-app" {
  count = "${length(var.vpc_subnet_app_cidrs)}"
  subnet_id = "${element(aws_subnet.sn-app.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.rtb-app.*.id, count.index)}"
}


resource "aws_route_table" "rtb-data" {
  count = "${length(var.vpc_subnet_data_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.tags,
                  map("Name", "rtb-${var.name}-data-${substr(element(var.vpc_availability_zones, count.index), -2, -1)}"))}"
}


resource "aws_route" "data-default" {
  count = "${length(var.vpc_subnet_data_cidrs)}"
  route_table_id = "${element(aws_route_table.rtb-data.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}


resource "aws_route_table_association" "data-data" {
  count = "${length(var.vpc_subnet_data_cidrs)}"
  subnet_id = "${element(aws_subnet.sn-data.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.rtb-data.*.id, count.index)}"
}
