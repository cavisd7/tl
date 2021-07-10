variable "cluster_name" {
    type        = string 
    description = "Name of EKS cluster"
}

variable "cluster_flavor" {
    type        = string 
    description = "Flavor of cluster to deploy: private, public, or balanced"
    default     = "balanced"

    validation {
        condition     = contains(["private", "public", "balanced"], var.cluster_flavor)
        error_message = "Valid values for var cluster_flavor are (private, public, balanced)"
    } 
}

variable "subnet_ids" {
    type        = list(string)
    description = "List of subnet ids where EKS will deploy worker nodes"
}

variable "cluster_log_types" {
    type        = list(string)
    description = "A list of EKS log types to enable. Logs are provided from the EKS control plane and sent to CloudWatch Logs. Valid options are: api, audit, authenticator, controllerManager, and scheduler"
    default     = ["api", "audit"]
}

variable "node_group_name" {
    type        = string 
}

variable "vpc_id" {
    type        = string 
}

variable "max_size" {
    type    = number
    default = 1
}

variable "min_size" {
    type    = string
    default = 1
}

variable "desired_size" {
    type    = string
    default = 1
}

variable "enable_private_endpoint" {
    type    = bool
    default = true
} 

variable "enable_public_endpoint" {
    type    = bool
    default = false
} 

