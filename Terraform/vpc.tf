resource "aws_vpc" "packer" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "packer"
    Description = "sample vpc with 2 public subnets in 2 availability zones and a network load balancer for high availability"
  }
}

resource "aws_internet_gateway" "inet" {
  vpc_id = aws_vpc.packer.id
  tags = {
    Name = "packer internet gateway"
  }
}

resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.packer.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inet.id
  }
  tags = {
    Name = "public route table"
  }
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.packer.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet a"
  }
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.packer.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet b"
  }
}
