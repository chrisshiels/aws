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
  count = "${length(var.publicsubnetcidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.availabilityzones, count.index)}"
  cidr_block = "${element(var.publicsubnetcidrs, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "sn-${var.name}-public-${substr(element(var.availabilityzones, count.index), -2, -1)}"
  }
}


resource "aws_subnet" "private" {
  count = "${length(var.privatesubnetcidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.availabilityzones, count.index)}"
  cidr_block = "${element(var.privatesubnetcidrs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "sn-${var.name}-private-${substr(element(var.availabilityzones, count.index), -2, -1)}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw-${var.name}"
  }
}


resource "aws_eip" "nat" {
  vpc = true
  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${element(aws_subnet.public.*.id, 0)}"

  tags {
    Name = "nat-${var.name}"
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
  count = "${length(var.publicsubnetcidrs)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-${var.name}-private"
  }
}


resource "aws_route" "private-default" {
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat.id}"
}


resource "aws_route_table_association" "private-private" {
  count = "${length(var.privatesubnetcidrs)}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
