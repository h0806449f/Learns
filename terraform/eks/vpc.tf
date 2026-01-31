### 
# vpc
###
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "henry-practice"
  }
}

### 
# subnet
###
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "ap-northeast-3a"
  map_public_ip_on_launch = true
  tags = {
    Name                                   = "public-subnet-1"
    "kubernetes.io/role/elb"               = "1"
    "kubernetes.io/cluster/henry-practice" = "shared"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "ap-northeast-3b"
  map_public_ip_on_launch = true
  tags = {
    Name                                   = "public-subnet-2"
    "kubernetes.io/role/elb"               = "1"
    "kubernetes.io/cluster/henry-practice" = "shared"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.128.0/18"
  availability_zone       = "ap-northeast-3a"
  map_public_ip_on_launch = false
  tags = {
    Name                                   = "private-subnet-1"
    "kubernetes.io/role/internal-elb"      = "1"
    "kubernetes.io/cluster/henry-practice" = "shared"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.192.0/18"
  availability_zone       = "ap-northeast-3b"
  map_public_ip_on_launch = false
  tags = {
    Name                                   = "private-subnet-2"
    "kubernetes.io/role/internal-elb"      = "1"
    "kubernetes.io/cluster/henry-practice" = "shared"
  }
}

### 
# gateway
###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_eip.nat_eip]
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


### 
# rtb
###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}
