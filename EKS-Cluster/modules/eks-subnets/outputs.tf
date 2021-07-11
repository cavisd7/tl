output "subnet_ids" {
    value = (
        concat(module.balanced_subnets.private_subnet_ids, module.balanced_subnets.public_subnet_ids) ||
        concat(module.private_subnets.private_subnet_ids, module.private_subnets.public_subnet_ids) ||
        concat(module.public_subnets.private_subnet_ids, module.public_subnets.public_subnet_ids)
    )
}