resource "aws_security_group" "ssh" {
  name        = "dev-ssh"
  description = "Allow SSH from my IP only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
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

resource "aws_security_group" "private_ssh_from_bastion" {
  name        = "dev-private-ssh"
  description = "Allow SSH only from bastion SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from bastion SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-private-ssh"
    Env  = "dev"
  }
}
