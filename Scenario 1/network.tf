# Virtual Private Cloud (VPC) and Subnets

resource "aws_vpc" "cea_vpc" {
  cidr_block            = var.vpc_cidr_block
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name                = "cea-vpc"
    Usage               = var.project_name
  }
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id                = aws_vpc.cea_vpc.id
  availability_zone     = var.aws_availability_zone1
  cidr_block            = var.private_subnet_1_cidr

  tags = {
    Name                = "cea-private-subnet-az1"
    Usage               = var.project_name
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                = aws_vpc.cea_vpc.id
  availability_zone     = var.aws_availability_zone2
  cidr_block            = var.private_subnet_2_cidr

  tags = {
    Name                = "cea-private-subnet-az2"
    Usage               = var.project_name
  }
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                = aws_vpc.cea_vpc.id
  availability_zone     = var.aws_availability_zone1
  cidr_block            = var.public_subnet_1_cidr

  tags = {
    Name                = "cea-public-subnet-az1"
    Usage               = var.project_name
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                = aws_vpc.cea_vpc.id
  availability_zone     = var.aws_availability_zone2
  cidr_block            = var.public_subnet_2_cidr

  tags = {
    Name                = "cea-public-subnet-az2"
    Usage               = var.project_name
  }
}

# Internet Gateway

resource "aws_internet_gateway" "cea_igw" {
  vpc_id                = aws_vpc.cea_vpc.id

  tags = {
    Name                = "cea-igw"
    Usage               = var.project_name
  }
}

# Route Table for Public Subnets

resource "aws_route_table" "public_rt" {
  vpc_id                = aws_vpc.cea_vpc.id

  route {
    cidr_block          = "0.0.0.0/0"
    gateway_id          = aws_internet_gateway.cea_igw.id
  }

  tags = {
    Name                = "cea-public-rt"
    Usage               = var.project_name
  }
}

resource "aws_route_table_association" "public_subnet_az1_assoc" {
  subnet_id             = aws_subnet.public_subnet_az1.id
  route_table_id        = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_az2_assoc" {
  subnet_id             = aws_subnet.public_subnet_az2.id
  route_table_id        = aws_route_table.public_rt.id
}

# Route Table for Private Subnets (No Internet Access)
resource "aws_route_table" "private_rt" {
  vpc_id                = aws_vpc.cea_vpc.id

  tags = {
    Name                = "cea-private-rt"
    Usage               = var.project_name
  }
}

resource "aws_route_table_association" "private_subnet_az1_assoc" {
  subnet_id             = aws_subnet.private_subnet_az1.id
  route_table_id        = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_az2_assoc" {
  subnet_id             = aws_subnet.private_subnet_az2.id
  route_table_id        = aws_route_table.private_rt.id
}