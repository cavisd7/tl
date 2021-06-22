output "private_subnet_ids" {
    value       = aws_subnet.private_subnet.*.id
    description = "A list of created private subnet ids"
}

output "public_subnet_ids" {
    value       = aws_subnet.public_subnet.*.id
    description = "A list of created public subnet ids"
}