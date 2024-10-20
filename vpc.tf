resource "aws_vpc" "training_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "training_subnet_1" {
  vpc_id            = aws_vpc.training_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "training_igw" {
  vpc_id = aws_vpc.training_vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "main-rtbl" {
  default_route_table_id = aws_vpc.training_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.training_igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rtbl"
  }
}
