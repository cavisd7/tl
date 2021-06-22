module "example_private_public_vpc" {
    source              = "../"

    vpc_cidr            = var.vpc_cidr
    vpc_tags            = var.vpc_tags
    subnet_count        = var.subnet_count
}