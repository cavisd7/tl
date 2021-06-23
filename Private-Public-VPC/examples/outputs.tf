output "vpc_id" {
    value       = module.example_private_public_vpc.vpc_id
    description = "The VPC id of the created VPC"
}

output "vpc_tags" {
    value       = module.example_private_public_vpc.vpc_tags
    description = "A map of tags applied to the created VPC"
}

output "private_subnet_ids" {
    value       = module.example_private_public_vpc.private_subnet_ids
    description = "A list of created private subnet ids"
}

output "public_subnet_ids" {
    value       = module.example_private_public_vpc.public_subnet_ids
    description = "A list of created public subnet ids"
}