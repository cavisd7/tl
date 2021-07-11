module "example_private_public_vpc" {
    source              = "../"

    vpc_cidr            = var.vpc_cidr
    vpc_tags            = var.vpc_tags
    public_subnet_tags  = var.public_subnet_tags
}