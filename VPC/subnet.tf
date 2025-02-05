//Subnets
resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-gov-west-1a"
  cidr_block        = "10.0.0.0/25"
  tags = {
    Name = "Public 1a"
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-gov-west-1a"
  cidr_block        = "10.0.1.0/25"
  tags = {
    Name = "Private 1a"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-gov-west-1b"
  cidr_block        = "10.0.0.128/25"
  tags = {
    Name = "Public 1b"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-gov-west-1b"
  cidr_block        = "10.0.1.128/25"
  tags = {
    Name = "Private 1b"
  }
}