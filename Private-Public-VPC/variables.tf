variable "vpc_cidr" {
    type        = string
    description = "The CIDR block for the VPC" 
}

variable "vpc_tags" {
    type        = map
    description = "Tags to be applied to VPC" 
    default     = {}
}

variable "public_subnet_count" {
    type        = number
    description = "The number of public subnets to create"
    default     = 2
}

variable "private_subnet_count" {
    type        = number
    description = "The number of private subnets to create"
    default     = 2
}

variable "public_subnet_tags" {
    type        = map 
    description = "A map of tags to be applied to all public subnets"
    default     = {}
}

variable "private_subnet_tags" {
    type        = map 
    description = "A map of tags to be applied to all private subnets"
    default     = {}
}