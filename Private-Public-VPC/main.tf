resource "aws_vpc" "vpc" {
    cidr_block      = var.vpc_cidr

    tags            = var.vpc_tags
}

module "private_public_subnets" {
    source              = "./modules/private-public-subnets"

    vpc_id              = aws_vpc.vpc.id
    //vpc_cidr            = var.vpc_cidr
    subnet_count        = var.subnet_count
}