resource "aws_internet_gateway" "django-igw" {
  vpc_id = aws_vpc.django-vpc.id
  tags = {
    Name = "rmaty-igw"
  }
}

resource "aws_route_table" "django-public-crt" {
  vpc_id = aws_vpc.django-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.django-igw.id
  }

  tags = {
    Name = "rmaty-public-crt"
  }
}

resource "aws_route_table_association" "django-crta-public-subnet-1" {
  subnet_id      = aws_subnet.django-subnet-public-1.id
  route_table_id = aws_route_table.django-public-crt.id
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = aws_vpc.django-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    // This means, all ip address are allowed to ssh ! 
    // Do not do it in the production. 
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["45.11.60.154/32"]
  }
  //If you do not add this rule, you can not reach the NGIX  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["45.11.60.154/32"]
  }
  tags = {
    Name = "rmaty-ssh-allowed"
  }
}