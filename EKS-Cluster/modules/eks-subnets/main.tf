module "private_public_subnets" {
    source          = "github.com/cavisd7/tl//Private-Public-VPC/modules/private-public-subnets"
    count           = var.cluster_flavor == "balanced" ? 1 : 0

    vpc_id          = var.vpc_id
    # Subnets should be /24
    cidr_newbits    = 8 

    public_subnet_tags  = {}
    private_subnet_tags = {}
}