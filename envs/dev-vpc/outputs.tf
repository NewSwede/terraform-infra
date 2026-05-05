output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_test_ip" {
  value = aws_instance.private_test.private_ip
}

output "nat_eip" {
  value = aws_eip.nat.public_ip
}

output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "vpc_id" {
  value = aws_vpc.main.id
}