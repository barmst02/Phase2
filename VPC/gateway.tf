//Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "VPC Internet Gateway"
  }
}

/*
//Elastic IPs for NAT GWs
resource "aws_eip" "eip-nat" {
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "EIP for NAT GW"
  }
}

// NAT GWs for private subnets (created in public subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.public-1a.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "NAT for Private Subnets"
  }
}
*/