resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "vpc-dev"
  }
}


resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "sn-dev-public"
  }
}


resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags {
    Name = "sn-dev-private"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw-dev"
  }
}


resource "aws_eip" "nat" {
  vpc = true
  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.id}"

  tags {
    Name = "nat-dev"
  }

  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-dev-public"
  }
}


resource "aws_route" "public-default" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}


resource "aws_route_table_association" "public-public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-dev-private"
  }
}


resource "aws_route" "private-default" {
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat.id}"
}


resource "aws_route_table_association" "private-private" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}
