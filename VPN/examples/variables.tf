variable "should_cleanup" {
    type        = bool
    description = "Select true to destroy resources when a change forces a new resource or when running 'terraform destroy'"
    default     = true
}

variable "vpc_id" {
    type        = string
    description = "VPC id to launch VPN in"
}

variable "desired_capacity" {
    type        = number
    description = "Desired number of VPN servers"
    default     = 1
}

variable "admin_ips" {
    type        = list(string)
    description = "A list of trusted IPs that OpenVPN security group will allow SSH traffic to and OpenVPN Admin Web UI access"
    //default     = [ "0.0.0.0/0" ]
}

/*variable "hosted_zone_id" {
    type        = string
    description = ""
}*/

variable "public_subnets" {
    type        = list(string)
    description = "A list of public subnets where VPN servers will be deployed. Specify at least two subnets in different AZs"
}