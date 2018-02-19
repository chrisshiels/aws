resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "vpc-${var.name}"
  }
}


resource "aws_subnet" "public" {
  count = "${length(var.subnet_public_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block = "${element(var.subnet_public_cidrs, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "sn-${var.name}-public-${substr(element(var.availability_zones, count.index), -2, -1)}"
  }
}


resource "aws_subnet" "app" {
  count = "${length(var.subnet_app_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block = "${element(var.subnet_app_cidrs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "sn-${var.name}-app-${substr(element(var.availability_zones, count.index), -2, -1)}"
  }
}


resource "aws_subnet" "data" {
  count = "${length(var.subnet_data_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block = "${element(var.subnet_data_cidrs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "sn-${var.name}-data-${substr(element(var.availability_zones, count.index), -2, -1)}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw-${var.name}"
  }
}


resource "aws_eip" "nat" {
  count = "${length(var.subnet_public_cidrs)}"
  vpc = true
  depends_on = [ "aws_internet_gateway.igw" ]

  tags {
    Name = "eip-${var.name}-natgw-${substr(element(var.availability_zones, count.index), -2, -1)}"
  }
}


resource "aws_nat_gateway" "nat" {
  count = "${length(var.subnet_public_cidrs)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"

  tags {
    Name = "nat-${var.name}-${substr(element(var.availability_zones, count.index), -2, -1)}"
  }

  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-${var.name}-public"
  }
}


resource "aws_route" "public-default" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}


resource "aws_route_table_association" "public-public" {
  count = "${length(var.subnet_public_cidrs)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table" "app" {
  count = "${length(var.subnet_app_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-${var.name}-app-${substr(element(var.availability_zones, count.index), -2, -1)}"
  }
}


resource "aws_route" "app-default" {
  count = "${length(var.subnet_app_cidrs)}"
  route_table_id = "${element(aws_route_table.app.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}


resource "aws_route_table_association" "app-app" {
  count = "${length(var.subnet_app_cidrs)}"
  subnet_id = "${element(aws_subnet.app.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.app.*.id, count.index)}"
}


resource "aws_route_table" "data" {
  count = "${length(var.subnet_data_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-${var.name}-data-${substr(element(var.availability_zones, count.index), -2, -1)}"
  }
}


resource "aws_route" "data-default" {
  count = "${length(var.subnet_data_cidrs)}"
  route_table_id = "${element(aws_route_table.data.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}


resource "aws_route_table_association" "data-data" {
  count = "${length(var.subnet_data_cidrs)}"
  subnet_id = "${element(aws_subnet.data.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.data.*.id, count.index)}"
}
