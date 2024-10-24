# VPC
resource "aws_vpc" "vpc_main" {
  cidr_block = var.vpc_cidr_block 
  tags = {
    Name = "${var.env_prefix}-training-vpc"
  }
}

# Creating 1st subnet 
resource "aws_subnet" "training_subnet_1" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.0.0/27" #32 IPs
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = "eu-west-1a"
}
# Creating 2nd subnet 
resource "aws_subnet" "training_subnet_1a" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.0.32/27" #32 IPs
  map_public_ip_on_launch = true           # public subnet
  availability_zone       = "eu-west-1b"
}
# Creating 2nd subnet 
resource "aws_subnet" "training_subnet_2" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.1.0/27" #32 IPs
  map_public_ip_on_launch = false         # private subnet
  availability_zone       = "eu-west-1b"
}




# GATEWAYS
# Internet Gateway
resource "aws_internet_gateway" "training_gw" {
  vpc_id = aws_vpc.vpc_main.id
}


# Elastic IP for NAT gateway
resource "aws_eip" "training_eip" {
  depends_on = [aws_internet_gateway.training_gw]
  tags = {
    Name = "training_EIP_for_NAT"
  }
}

# NAT gateway for private subnets - for the private subnet to access internet
# like ec2 instances downloading softwares etc.
resource "aws_nat_gateway" "training_nat_for_private_subnet" {
  allocation_id = aws_eip.training_eip.id
  subnet_id     = aws_subnet.training_subnet_1.id // nat should be in public subnet

  tags = {
    Name = "Sh NAT for private subnet"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.training_gw]
}

#   ROUTE TABLES
# route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "training_rt_public" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.training_gw.id
  }
}

# associate the route table with public subnet 1
resource "aws_route_table_association" "training_rta1" {
  subnet_id      = aws_subnet.training_subnet_1.id
  route_table_id = aws_route_table.training_rt_public.id
}
# associate the route table with public subnet 1a
resource "aws_route_table_association" "training_rta2" {
  subnet_id      = aws_subnet.training_subnet_1a.id
  route_table_id = aws_route_table.training_rt_public.id
}


# route table for private subnet - connecting to NAT
resource "aws_route_table" "training_rt_private" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.training_nat_for_private_subnet.id
  }
}

# associate the route table with private subnet 2
resource "aws_route_table_association" "training_rta3" {
  subnet_id      = aws_subnet.training_subnet_2.id
  route_table_id = aws_route_table.training_rt_private.id
}
