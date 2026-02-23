output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_test_ip" {
  value = aws_instance.private_test.private_ip
}

output "nat_eip" {
  value = aws_eip.nat.public_ip
}
