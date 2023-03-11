resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Altschool-VPC"
 }
}


# create subnets
resource "aws_subnet" "public-1-subnet" {
 vpc_id     = aws_vpc.main.id
 cidr_block = "10.0.1.0/24"
 availability_zone = "us-east-1b"
 tags = {
  Name = "Public Subnet-1"
 }
}

resource "aws_subnet" "public-2-subnet"{
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public subnet-2"
  }
}


resource "aws_subnet" "eks_private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "eks-private-subnet-1"
  }
}

resource "aws_subnet" "eks_private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "eks-private-subnet-2"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-igw"
  }
}

# Create a route table for the public subnets and associate it with the public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "eks_public_subnet_1_association" {
  subnet_id      = aws_subnet.public-1-subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "eks_public_subnet_2_association" {
  subnet_id      = aws_subnet.public-2-subnet.id
  route_table_id = aws_route_table.public_rt.id
}



resource "aws_eip" "nat_eip" {
  vpc = true 

  tags = {
    name = "alt-eip"
  }
}

# Create a NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-2-subnet.id
}



resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route" "private_nat_gateway_route" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.nat_gateway.id
}


resource "aws_route_table_association" "private1" {
  subnet_id = aws_subnet.eks_private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2" {
  subnet_id = aws_subnet.eks_private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

