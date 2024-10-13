resource "aws_vpc" "myapp_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyApp VPC"
  }
}

resource "aws_subnet" "myapp_subnet_a" {
  vpc_id            = aws_vpc.myapp_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "MyApp Subnet A"
  }
}

resource "aws_subnet" "myapp_subnet_b" {
  vpc_id            = aws_vpc.myapp_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "MyApp Subnet B"
  }
}

resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = aws_vpc.myapp_vpc.id

  tags = {
    Name = "MyApp IGW"
  }
}

resource "aws_route_table" "myapp_route_table" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp_igw.id
  }

  tags = {
    Name = "MyApp Route Table"
  }
}

resource "aws_route_table_association" "myapp_subnet_a_association" {
  subnet_id      = aws_subnet.myapp_subnet_a.id
  route_table_id = aws_route_table.myapp_route_table.id
}

resource "aws_route_table_association" "myapp_subnet_b_association" {
  subnet_id      = aws_subnet.myapp_subnet_b.id
  route_table_id = aws_route_table.myapp_route_table.id
}
