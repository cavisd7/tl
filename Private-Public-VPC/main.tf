resource "aws_vpc" "vpc" {
    cidr_block      = var.vpc_cidr

    tags            = var.vpc_tags
}

module "private_public_subnets" {
    source                  = "./modules/private-public-subnets"

    vpc_id                  = aws_vpc.vpc.id
    public_subnet_count     = var.public_subnet_count
    private_subnet_count    = var.private_subnet_count
}