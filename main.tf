resource "aws_instance" "Server" {
  ami                    = "ami-0bb84b8ffd87024d8"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_1.id
  vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id]
  tags = {
    Name = "Myserver"
  }
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "demo-gw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }

  tags = {
    Name = "demo_route_table"
  }
}

resource "aws_route_table_association" "rt-associtaion" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.demo_route_table.id
}

resource "aws_security_group" "demo-vpc-sg" {
  name   = "demo-vpc-sg"
  vpc_id = aws_vpc.demo_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_tls"
  }
}
output "public_ip" {
  value = aws_instance.Server.public_ip
}
