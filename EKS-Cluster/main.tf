data "aws_iam_policy_document" "eks_cluster_role_policy" {
    statement {
        effect  = "Allow"
        actions = [ "sts:AssumeRole" ]

        principals {
            type        = "Service"
            identifiers = [ "eks.amazonaws.com" ]
        }
    }
}

resource "aws_iam_role" "eks_cluster_role" {
    assume_role_policy  = data.aws_iam_policy_document.eks_cluster_role_policy.json
    managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
    name                = "EKSClusterRole"
}

resource "aws_eks_cluster" "eks_cluster" {
    name                        = var.cluster_name
    role_arn                    = aws_iam_role.eks_cluster_role.arn
    enabled_cluster_log_types   = var.cluster_log_types

    vpc_config {
        subnet_ids = var.subnet_ids
    }
}