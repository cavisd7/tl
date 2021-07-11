module "example_eks_cluster" {
    source              = "../"

    cluster_name        = var.cluster_name
    cluster_flavor      = var.cluster_flavor
    cluster_log_types   = var.cluster_log_types

    node_group_name     = var.node_group_name
    vpc_id              = var.vpc_id

    max_size            = var.max_size
    min_size            = var.min_size
    desired_size        = var.desired_size

    enable_private_endpoint     = var.enable_private_endpoint
    enable_public_endpoint      = var.enable_public_endpoint
    allowed_eks_endpoint_cidrs  = var.allowed_eks_endpoint_cidrs
}