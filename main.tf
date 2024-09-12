# Define the provider
provider "aws" {
  region = "us-east-1" # You can change this region as needed
}

# Create a VPC
resource "aws_vpc" "intech_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "intech-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "intech_public_subnet" {
  vpc_id     = aws_vpc.intech_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "intech-public-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "intech_igw" {
  vpc_id = aws_vpc.intech_vpc.id
  tags = {
    Name = "intech-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "intech_public_rt" {
  vpc_id = aws_vpc.intech_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.intech_igw.id
  }
  tags = {
    Name = "intech-public-rt"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "intech_public_rta" {
  subnet_id      = aws_subnet.intech_public_subnet.id
  route_table_id = aws_route_table.intech_public_rt.id
}

# Create a security group allowing SSH and HTTP
resource "aws_security_group" "intech_sg" {
  vpc_id = aws_vpc.intech_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "intech-sg"
  }
}

# Find the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's owner ID for Ubuntu images

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Create an EC2 instance with detailed monitoring enabled
resource "aws_instance" "intech_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.intech_public_subnet.id
  vpc_security_group_ids = [aws_security_group.intech_sg.id]
  key_name        = var.key_pair
  monitoring      = true  # Enable detailed monitoring

  tags = {
    Name = "intech-ubuntu-instance"
  }
}


