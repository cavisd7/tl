# Public flavor will:
#   Set give all worker node instances a public IP address via mapPublicIpOnLaunch on the subnet
#   
variable "cluster_flavor" {
    type        = string 
    description = "Flavor of cluster to deploy: private, public, or balanced"
    default     = "balanced"

    validation {
        condition     = contains(["private", "public", "balanced"], var.cluster_flavor)
        error_message = "Valid values for var cluster_flavor are (private, public, balanced)"
    } 
}

variable "vpc_id" {
    type        = string
    description = "The id of VPC"
}

variable "cluster_name" {
    type        = string 
    description = "The name of the EKS cluster"
}