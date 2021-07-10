module "example_eks_cluster" {
    source              = "../"

    cluster_name        = var.cluster_name
    subnet_ids          = var.subnet_ids
    cluster_log_types   = var.cluster_log_types
}