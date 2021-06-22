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