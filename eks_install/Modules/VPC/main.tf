resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name                                           = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}"    = "shared"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name                                           = "${var.cluster_name}-private-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}"    = "shared"
    "kubernetes.io/role/internal-elb"              = "1"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name                                           = "${var.cluster_name}-public-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}"    = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr)
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat-${count.index+1}"
  }
}

resource "aws_nat_gateway" "my_nat" {
  count = length(var.public_subnet_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.cluster_name}-nat-${count.index+1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "${var.cluster_name}-public"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.my_vpc.id 

  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat[count.index].id
  }

  tags = {
    Name = "${var.cluster_name}-private-${count.index+1}"
  }
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
    route_table_id = aws_route_table.private[count.index].id
    subnet_id = aws_subnet.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  route_table_id = aws_route_table.public
  subnet_id = aws_subnet.public[count.index].id
}