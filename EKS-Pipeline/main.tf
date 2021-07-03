locals {
    codebuild_log_group_name = "${var.pipeline_name}-build"
}

/*
 * CodePipeline Artifact Bucket
 */

resource "aws_s3_bucket" "pipeline_artifact_bucket" {
    bucket              = var.pipeline_bucket_name

    force_destroy       = var.should_cleanup

    tags = {
        pipeline = "true"
    }
}

/*
 * CodeBuild Logs Bucket
 */

resource "aws_s3_bucket" "codebuild_logs_bucket" {
    bucket              = var.codebuild_bucket_name

    force_destroy       = var.should_cleanup
}

/*
 * CodeBuild Project CloudWatch Log Group 
 */

resource "aws_cloudwatch_log_group" "apply_codebuild_log_group" {
    name                = local.codebuild_log_group_name
    retention_in_days   = "7"
}

/*
 * CodeStart Connection
 */

resource "aws_codestarconnections_connection" "github_connection" {
    name                = var.codestar_connection_name
    provider_type       = "GitHub"
}

/*
 *  CodePipeline Service Role Permissions
 */

data "aws_iam_policy_document" "codepipeline_service_role_policy" {
    statement {
        sid = "S3Read"

        actions = [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning"
        ]

        resources = ["arn:aws:s3:::${var.pipeline_bucket_name}"]

        effect = "Allow"
    }

    statement {
        sid = "S3Write"

        actions = [
            "s3:PutObject"
        ]

        resources = ["arn:aws:s3:::${var.pipeline_bucket_name}"]

        effect = "Allow"
    }

    statement {
        sid = "AllowGeneralServices"

        actions = [
            "ec2:*",
            "elasticloadbalancing:*",
            "autoscaling:*",
            "cloudwatch:*",
            "s3:*",
            "sns:*",
            "cloudformation:*",
            "rds:*",
            "sqs:*",
            "ecs:*",
            "iam:PassRole"
        ]

        resources = ["*"]

        effect = "Allow"
    }

    statement {
        sid = "CodeBuildPermissions"

        actions = [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
            "codebuild:StartBuildBatch"
        ]

        resources = ["${aws_codebuild_project.eks_build.arn}"]

        effect = "Allow"
    }

    statement {
        sid = "AllowCodeStarConnection"

        actions = ["codestar-connections:UseConnection"]

        resources = ["${var.codestar_connection_arn}"]

        effect = "Allow"
    }
}

/*
 *  CodePipeline Service Role
 */

resource "aws_iam_role" "codepipeline_service_role" {
    name = "EKSCodePipelineServiceRole"
    description = "CodePipeline service role for running EKS pipeline"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AssumableByCodePipeline",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "codepipeline.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF

    inline_policy {
        name = "CodePipelinePermissions"
        policy = data.aws_iam_policy_document.codepipeline_service_role_policy.json
    }

    tags = {
        pipeline = "true"
    }
}

/*
 *  CodeBuild Service Role Permissions
 *  TODO: Tighten permissions
 */

data "aws_iam_policy_document" "codebuild_service_role_policy" {
    statement {
        sid         = "AllowGeneralServices"
        resources   = ["*"]
        effect      = "Allow"
        actions = [
            "logs:*", 
            "s3:*", 
            "codebuild:*", 
            "secretsmanager:*",
            "iam:*",
            "organizations:*",
            "cloudtrail:*"
        ]
    }
}

/*
 *  CodeBuild Service Role
 */

resource "aws_iam_role" "codebuild_service_role" {
    name        = "EKSCodeBuildServiceRole"
    description = "CodeBuild service role for building EKS project"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AssumableByCodeBuild",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF

    inline_policy {
        name = "CodeBuildPermissions"
        policy = data.aws_iam_policy_document.codebuild_service_role_policy.json
    }
}

/*
 * CodeBuild project used as the terraform plan stage in the pipeline
 */

resource "aws_codebuild_project" "eks_build" {
    name                = "${var.pipeline_name}-build"
    description         = "Build docker images, push to ECR, and apply config files to EKS cluster"
    build_timeout       = "10"
    service_role        = aws_iam_role.codebuild_service_role.arn

    artifacts {
        type            = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "SERVICE_ROLE"
    }

    source {
        type            = "CODEPIPELINE"
        buildspec       = file("buildspec/${var.buildspec_file_name}")
    } 

    logs_config {
        cloudwatch_logs {
            group_name  = local.codebuild_log_group_name
        }

        s3_logs {
            status      = "ENABLED"
            location    = "${aws_s3_bucket.codebuild_logs_bucket.id}/${local.codebuild_log_group_name}"
        }
    }
}

/*
 * CodePipeline pipeline for EKS   
 */

resource "aws_codepipeline" "org_infra_codepipeline" {
    name                = var.pipeline_name
    role_arn            = var.codepipeline_service_role_arn

    artifact_store {
        type            = "S3"
        location        = aws_s3_bucket.pipeline_artifact_bucket.bucket

        dynamic "encryption_key" {
            for_each = var.pipeline_bucket_kms_alias_arn ? [1] : []
            content {
                id   = var.pipeline_bucket_kms_alias_arn
                type = "KMS"
            }
        }
    }

    stage {
        name            = "Source"

        action {
            name                = "Source"
            category            = "Source"
            owner               = "AWS"
            provider            = "CodeStarSourceConnection"
            version             = "1"
            output_artifacts    = ["ekscode"]
            configuration = {
                FullRepositoryId        = var.full_repo_id
                BranchName              = var.branch_name
                ConnectionArn           = aws_codestarconnections_connection.github_connection.arn
                OutputArtifactFormat    = "CODE_ZIP"
            }
        }
    }

    stage {
        name = "Build and Push"

        action {
            name                = "Build"
            category            = "Build"
            owner               = "AWS"
            provider            = "CodeBuild"
            input_artifacts     = ["ekscode"]
            version             = "1"

            configuration = {
                ProjectName     = aws_codebuild_project.eks_build.id
                PrimarySource   = "ekscode"
            }
        }
    }
}