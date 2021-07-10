variable "vpc_id" {
    type = string
}

variable "cluster_name" {
    type = string 
}

variable "node_group_name" {
    type = string 
}

variable "subnet_ids" {
    type = list(string)
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

variable "ami_id" {
    type    = string 
    default = ""
    description = "Default will use current version of AWS' EKS optimized AMI"
}

variable "map_public_ip" {
    type        = bool 
    default     = false
    description = "Enable or disable mapping of public IP to worker node instances."
}

variable "enable_private_endpoint" {
    type    = bool
    default = true
} 

variable "enable_public_endpoint" {
    type    = bool
    default = false
} 