# VPC
resource "aws_vpc" "sh_main" {
  cidr_block = "10.0.0.0/23" # 512 IPs 
  tags = {
    Name = "sharmi-vpc"
  }
}

# Creating 1st subnet 
resource "aws_subnet" "sh_subnet_1" {
  vpc_id                  = aws_vpc.sh_main.id
  cidr_block              = "10.0.0.0/27" #32 IPs
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = "us-east-1a"
}
# Creating 2nd subnet 
resource "aws_subnet" "sh_subnet_1a" {
  vpc_id                  = aws_vpc.sh_main.id
  cidr_block              = "10.0.0.32/27" #32 IPs
  map_public_ip_on_launch = true           # public subnet
  availability_zone       = "us-east-1b"
}
# Creating 2nd subnet 
resource "aws_subnet" "sh_subnet_2" {
  vpc_id                  = aws_vpc.sh_main.id
  cidr_block              = "10.0.1.0/27" #32 IPs
  map_public_ip_on_launch = false         # private subnet
  availability_zone       = "us-east-1b"
}

# Internet Gateway
resource "aws_internet_gateway" "sh_gw" {
  vpc_id = aws_vpc.sh_main.id
}

# route table
resource "aws_route_table" "sh_rt" {
  vpc_id = aws_vpc.sh_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sh_gw.id
  }
}

# associate the route table with public subnet
resource "aws_route_table_association" "sh_rta1" {
  subnet_id      = aws_subnet.sh_subnet_1.id
  route_table_id = aws_route_table.sh_rt.id
}
# associate the route table with public subnet
resource "aws_route_table_association" "sh_rta2" {
  subnet_id      = aws_subnet.sh_subnet_1a.id
  route_table_id = aws_route_table.sh_rt.id
}