variable "should_cleanup" {
    type        = bool
    description = "Select true to destroy resources when a change forces a new resource or when running 'terraform destroy'"
    default     = true
}

variable "pipeline_bucket_name" {
    type        = string
    description = "Name of S3 bucket that will store CodePipeline artifacts"
}

variable "codebuild_bucket_name" {
    type        = string
    description = "Name of S3 bucket that will store CodeBuild artifacts"
}

variable "pipeline_name" {
    type        = string
    description = "Name of EKS CodePipeline pipeline"
}

variable "codestar_connection_name" {
    type        = string 
    description = "Name of Github CodeStar connection. Will have to manually authenticate with Github account in AWS console"
}

variable "full_repo_id" {
    type        = string
    description = "Repository id that CodePipeline will source from"
}

variable "branch_name" {
    type        = string
    description = "Branch name in selected repository that CodePipeline will source from"
}

variable "buildspec_file_name" {
    type        = string 
    description = "Full file name (including extension) of CodeBuild buildspec file located in 'buildspec' directory in your repository to use for EKS build. e.g. buildspec/<buildspec_file_name>"
}

variable "pipeline_bucket_kms_alias_arn" {
    type        = string 
    default     = ""
}