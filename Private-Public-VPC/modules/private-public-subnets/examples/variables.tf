variable "vpc_id" {
    type        = string
    description = "The id of VPC"
}

/*variable "vpc_cidr" {
    type        = string
    description = "The CIDR block for the VPC"
}*/ 

# Limit for available AZs
variable "subnet_count" {
    type        = string
    description = "The number of public and private subnets to create"
}

variable "multi_nat_gateway" {
    type        = bool 
    description = "Select true to create a NAT Gateway and associate with each private subnet created. Select false to create a single NAT Gateway that all private subnets will share."
    default     = false
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

variable "cidr_newbits" {
    type        = number
    default     = 8
}

variable "should_map_public_ips" {
    type        = bool
    default     = false
}