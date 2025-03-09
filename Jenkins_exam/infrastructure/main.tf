terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# VPC
resource "aws_vpc" "luan_jenkins_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "luan_Jenkins_vpc"
  }
}

# Subnet
resource "aws_subnet" "jenkins_subnet" {
  vpc_id     = aws_vpc.luan_jenkins_vpc.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Jenkins-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.luan_jenkins_vpc.id
  tags = {
    Name = "Jenkins-InternetGateway"
  }
}

# Route Table
resource "aws_route_table" "jenkins_route_table" {
  vpc_id = aws_vpc.luan_jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "jenkins_route_table_assoc" {
  subnet_id      = aws_subnet.jenkins_subnet.id
  route_table_id = aws_route_table.jenkins_route_table.id
}

# Security group
resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.luan_jenkins_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Allow Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-SG"
  }
}

# Create Jenkins EC2 instance
# Jenkins Master
resource "aws_instance" "jenkins_master" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.jenkins_subnet.id
  key_name      = var.key_name
  security_groups = [aws_security_group.jenkins_sg.id]

  user_data = file("user_data/jenkins_master.sh")

  tags = {
    Name        = "Jenkins-Master_Luan"
    Role        = "Master"
    Environment = "Development"
  }
}

# Jenkins Worker
resource "aws_instance" "jenkins_worker" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.jenkins_subnet.id
  key_name      = var.key_name
  security_groups = [aws_security_group.jenkins_sg.id]

  user_data = file("user_data/jenkins_worker.sh")

  tags = {
    Name        = "Jenkins-Worker_Luan"
    Role        = "Worker"
    Environment = "Development"
  }
}

# Fetch AMI for Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
