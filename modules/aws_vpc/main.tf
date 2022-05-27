resource aws_vpc main {
  cidr_block           = var.cidr_network
  enable_dns_hostnames = true
  tags                 = {
    Name        = "${var.name}-vpc"
    Environment = var.environment
  }

}
resource aws_internet_gateway main {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name        = "${var.name}-igw"
    Environment = var.environment
  }
}

resource aws_route_table route {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags   = {
    Name        = "${var.name}-subnet_route"
    Environment = var.environment
  }
}


resource aws_subnet main {
  count                   = length(local.main_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.main_subnets[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags                    = {
    Name        = "${var.name}-subnet"
    Environment = var.environment
  }
  map_public_ip_on_launch = true
}

resource aws_route_table_association main {
  count          = length(local.main_subnets)
  subnet_id      = element(aws_subnet.main.*.id, count.index)
  route_table_id = element(aws_route_table.route.*.id, count.index)
}