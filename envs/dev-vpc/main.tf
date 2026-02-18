terraform {
  backend "s3" {
    bucket         = "tfstate-terraform-infra-0d47477c"
    key            = "dev-vpc/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-locks-terraform-infra"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

# 1) VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-vpc"
    Env  = "dev"
  }
}

# 2) Internet Gateway (attachée au VPC)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-igw"
    Env  = "dev"
  }
}

# 3) Public Subnet (AZ A)
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-a"
    Env  = "dev"
    Tier = "public"
  }
}

# 4) Private Subnet (AZ A)
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "dev-private-a"
    Env  = "dev"
    Tier = "private"
  }
}

# 5) Route table publique
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-rt-public"
    Env  = "dev"
  }
}

# 6) Route vers Internet (0.0.0.0/0 -> IGW)
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# 7) Associer la route table publique au subnet public
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ssh" {
  name        = "dev-ssh"
  description = "Allow SSH from my IP only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["88.121.39.79/32"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-ssh"
    Env  = "dev"
  }
}


data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = "dev-key"
  associate_public_ip_address = true

  tags = {
    Name = "dev-bastion"
    Env  = "dev"
  }
}
