module "example_private_public_subnets" {
    source          = "../"

    vpc_id                  = var.vpc_id
    public_subnet_count     = var.public_subnet_count
    private_subnet_count    = var.private_subnet_count
    multi_nat_gateway       = var.multi_nat_gateway
}