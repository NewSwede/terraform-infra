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

resource "aws_instance" "private_test" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_a.id
  vpc_security_group_ids      = [aws_security_group.private_ssh_from_bastion.id]
  key_name                    = "dev-key"
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.private_ec2.name

  tags = {
    Name = "dev-private-test"
    Env  = "dev"
  }
}
