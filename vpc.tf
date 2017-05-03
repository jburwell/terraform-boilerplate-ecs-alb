/**
 * Main VPC
 */
resource "aws_vpc" "main" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
      Name = "${var.project}"
      Group = "${var.project}"
  }
}

/**
 * Internet gateway for main VPC
 */
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.project}"
    Group = "${var.project}"
  }
}

/**
 * Primary subnet
 */
resource "aws_subnet" "primary" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "172.31.0.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"


  map_public_ip_on_launch = true

  tags {
    Name = "${var.project}"
  }
}

/**
 * Secondary subnet
 */
resource "aws_subnet" "secondary" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "172.31.16.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.project}"
  }
}

/**
 * Route table for vpc
 */
resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.project}"
  }
}

/**
 * Route table association for primary subnet
 */
resource "aws_route_table_association" "primary" {
  subnet_id = "${aws_subnet.primary.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

/**
 * Route table association for secondary subnet
 */
resource "aws_route_table_association" "secondary" {
  subnet_id = "${aws_subnet.secondary.id}"
  route_table_id = "${aws_route_table.rt.id}"
}
