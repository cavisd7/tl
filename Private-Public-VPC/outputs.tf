output "vpc_id" {
    value       = aws_vpc.vpc.id
    description = "The VPC id of the created VPC"
}

output "private_subnet_ids" {
    value       = module.private_public_subnets.private_subnet_ids
    description = "A list of created private subnet ids"
}

output "public_subnet_ids" {
    value       = module.private_public_subnets.public_subnet_ids
    description = "A list of created public subnet ids"
}