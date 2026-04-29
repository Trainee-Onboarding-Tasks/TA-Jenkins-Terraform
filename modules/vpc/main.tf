
resource "aws_vpc" "system_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "System vpc"
  }
}


resource "aws_subnet" "public_subnets" {
  for_each = {
    for idx, cidr in var.public_subnets :
    idx => cidr
  }

  vpc_id                  = aws_vpc.system_vpc.id
  cidr_block              = each.value
  availability_zone       = element(var.available_zones_list, each.key % length(var.available_zones_list))
  map_public_ip_on_launch = true

  tags = {
    Name = "System public subnet"
  }
}


resource "aws_subnet" "private_servers_subnets" {
  for_each = {
    for idx, cidr in var.private_servers_subnets :
    idx => cidr
  }

  vpc_id            = aws_vpc.system_vpc.id
  cidr_block        = each.value
  availability_zone = element(var.available_zones_list, each.key % length(var.available_zones_list))

  tags = {
    Name = "System Jenkins server private subnet"
  }
}


resource "aws_internet_gateway" "system_igw" {
  vpc_id = aws_vpc.system_vpc.id

  tags = {
    Name = "System igw"
  }
}


resource "aws_eip" "system_eip" {
  domain = "vpc"

  tags = {
    Name = "System eip"
  }
}


resource "aws_nat_gateway" "system_nat" {
  allocation_id = aws_eip.system_eip.id
  subnet_id     = values(aws_subnet.public_subnets)[0].id

  tags = {
    Name = "System nat"
  }
}


resource "aws_route_table" "system_public_route_table" {
  vpc_id       = aws_vpc.system_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.system_igw.id
  }

  tags = {
    Name = "System public route table"
  }
}


resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.system_public_route_table.id
}


resource "aws_route_table" "system_private_route_table" {
  vpc_id = aws_vpc.system_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.system_nat.id
  }

  tags = {
    Name = "System private route table"
  }
}


resource "aws_route_table_association" "private_servers_assoc" {
  for_each       = aws_subnet.private_servers_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.system_private_route_table.id
}
