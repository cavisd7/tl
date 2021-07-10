module "example_private_public_subnets" {
    source          = "../"

    vpc_id          = var.vpc_id
    subnet_count    = var.subnet_count
}