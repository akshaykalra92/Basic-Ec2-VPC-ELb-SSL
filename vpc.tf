/*==== The VPC ======*/
resource "aws_vpc" "resource" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "Application-1"
  }
}
/*==== Subnets ======*/
resource "aws_internet_gateway" "resource-igw" {
  vpc_id = aws_vpc.resource.id
  tags = {
    "Name" = "Application-1-gateway"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.resource.id
  count             = "${length(var.public_subnets_cidr)}"
  cidr_block        = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "Application-1-public-1a"
    "Tier" = "Public"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "resource-rt" {
  vpc_id = aws_vpc.resource.id
  tags = {
    "Name" = "Application-1-route-table"
  }
}

resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.resource-rt.id
  gateway_id             = aws_internet_gateway.resource-igw.id
}

/* Route table associations */
resource "aws_route_table_association" "public-1a" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public-1a.*.id, count.index)}"
  route_table_id = aws_route_table.resource-rt.id
}