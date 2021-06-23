variable "vpc_id" {
    type        = string
    description = "The id of VPC"
}

variable "vpc_cidr" {
    type        = string
    description = "The CIDR block for the VPC"
} 

# Limit for available AZs
variable "subnet_count" {
    type        = string
    description = "The number of public and private subnets to create"
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