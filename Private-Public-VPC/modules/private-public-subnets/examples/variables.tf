variable "vpc_id" {
    type        = string
    description = "The id of VPC"
}

variable "public_subnet_count" {
    type        = string
    description = "The number of public subnets to create"
}

variable "private_subnet_count" {
    type        = number
    description = "The number of private subnets to create"
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
    description = "Enable mapping of public IPs when instances are launched into public subnet only. Does not apply to private subnet"
}