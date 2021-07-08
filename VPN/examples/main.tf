module "example_vpn" {
    source              = "../"

    vpc_id              = var.vpc_id
    admin_ips           = var.admin_ips
    public_subnets      = var.public_subnets
    hosted_zone_id      = var.hosted_zone_id
    vpn_dns_name        = var.vpn_dns_name
    desired_capacity    = var.desired_capacity
}