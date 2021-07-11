module "balanced_subnets" {
    //source                  = "github.com/cavisd7/tl//Private-Public-VPC/modules/private-public-subnets"
    source                  = "../../../Private-Public-VPC/modules/private-public-subnets/"
    count                   = var.cluster_flavor == "balanced" ? 1 : 0

    vpc_id                  = var.vpc_id
    public_subnet_count     = 2
    private_subnet_count    = 2

    # Subnets should be /24
    cidr_newbits            = 8 
    should_map_public_ips   = true

    public_subnet_tags = {
        "kubernetes.io/cluster/${var.cluster_name}" : "shared",
        "kubernetes.io/role/elb" : 1
    }
    private_subnet_tags = {
        "kubernetes.io/cluster/${var.cluster_name}" : "shared",
        "kubernetes.io/role/internal-elb" : 1
    }
}

module "private_subnets" {
    source                  = "../../../Private-Public-VPC/modules/private-public-subnets/"
    //source                  = "github.com/cavisd7/tl//Private-Public-VPC/modules/private-public-subnets"
    count                   = var.cluster_flavor == "private" ? 1 : 0

    vpc_id                  = var.vpc_id
    public_subnet_count     = 0
    private_subnet_count    = 3

    # Subnets should be /24
    cidr_newbits    = 8 

    private_subnet_tags = {
        "kubernetes.io/cluster/${var.cluster_name}" : "shared",
        "kubernetes.io/role/internal-elb" : 1
    }
}

module "public_subnets" {
    source                  = "../../../Private-Public-VPC/modules/private-public-subnets/"
    //source                  = "github.com/cavisd7/tl//Private-Public-VPC/modules/private-public-subnets"
    count                   = var.cluster_flavor == "public" ? 1 : 0

    vpc_id                  = var.vpc_id
    public_subnet_count     = 3
    private_subnet_count    = 0

    # Subnets should be /24
    cidr_newbits            = 8 
    should_map_public_ips   = true

    public_subnet_tags = {
        "kubernetes.io/cluster/${var.cluster_name}" : "shared",
        "kubernetes.io/role/elb" : 1
    }
}