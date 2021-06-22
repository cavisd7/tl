variable "vpc_cidr" {
    type        = string
    description = "The CIDR block for the VPC" 
}

variable "vpc_tags" {
    type        = map
    description = "Tags to be applied to VPC" 
    default     = {}
}

variable "subnet_count" {
    type        = string
    description = "The number of public and private subnets to create"
    default     = 2
}