# 1. The Virtual Private Cloud
resource "aws_vpc" "vpc-3tier-demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "saksham-3tier-vpc" }
}

# 2. Internet Gateway (For Public Access)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-3tier-demo.id
  tags   = { Name = "main-igw" }
}

# 3. Public Subnets (For Load Balancer)
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-3tier-demo.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-1a" }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc-3tier-demo.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-1b" }
}

# 4. App Subnets (Private - For EC2 Instances)
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.vpc-3tier-demo.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "app-private-1a" }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.vpc-3tier-demo.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "app-private-1b" }
}

# 5. DB Subnets (Private - For RDS)
resource "aws_subnet" "private-subnet-3" {
  vpc_id            = aws_vpc.vpc-3tier-demo.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "db-private-1a" }
}

resource "aws_subnet" "private-subnet-4" {
  vpc_id            = aws_vpc.vpc-3tier-demo.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "db-private-1b" }
}

# 6. NAT Gateway (For Private Subnets to reach the internet)
resource "aws_eip" "nat_eip" { domain = "vpc" }

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnet-1.id
  tags          = { Name = "main-nat-gw" }
}

# 7. PUBLIC Route Table & Associations
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc-3tier-demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-route-table" }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public_rt.id
}

# 8. PRIVATE Route Table & Associations
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc-3tier-demo.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = "private-route-table" }
}

resource "aws_route_table_association" "app_1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "app_2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private_rt.id
}