module "example_vpn" {
    source              = "../"

    vpc_id              = var.vpc_id
    admin_ips           = var.admin_ips
    public_subnets      = var.public_subnets
}