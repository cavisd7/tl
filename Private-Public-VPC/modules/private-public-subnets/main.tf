locals {
    ngw_qty = (
        var.multi_nat_gateway && (var.public_subnet_count >= var.private_subnet_count) ? var.private_subnet_count : ( 
            var.multi_nat_gateway && (var.private_subnet_count >= var.public_subnet_count) ? var.public_subnet_count : 1
        )
    )
}

data "aws_availability_zones" "azs" {
    state = "available"
}

data "aws_vpc" "selected" {
    id  = var.vpc_id
}

resource "aws_internet_gateway" "igw" {
    vpc_id      = var.vpc_id
}

resource "aws_subnet" "public_subnet" {
    count                   = var.public_subnet_count

    vpc_id                  = var.vpc_id
    # Assuming a /16 VPC CIDR block, will result in a /24 CIDR block for the subnet
    cidr_block              = cidrsubnet(data.aws_vpc.selected.cidr_block, var.cidr_newbits, count.index)
    availability_zone       = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]

    map_public_ip_on_launch = var.should_map_public_ips

    tags                    = merge({ Name = "Public ${count.index}" }, var.public_subnet_tags)
}

resource "aws_eip" "nat_eip" {
    count       = local.ngw_qty
    vpc         = true
}

resource "aws_nat_gateway" "ngw" {
    count = local.ngw_qty

    allocation_id   = aws_eip.nat_eip[count.index].id
    subnet_id       = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table" "public_rt" {
    vpc_id          = var.vpc_id
}

resource "aws_route" "public_route" {
    route_table_id         = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_route_join" {
    count           = var.public_subnet_count 

    route_table_id  = aws_route_table.public_rt.id
    subnet_id       = aws_subnet.public_subnet[count.index].id
}

resource "aws_subnet" "private_subnet" {
    count               = var.private_subnet_count 

    vpc_id              = var.vpc_id
    # Assuming a /16 VPC CIDR block, will result in a /24 CIDR block for the subnet
    cidr_block          = cidrsubnet(data.aws_vpc.selected.cidr_block, var.cidr_newbits, count.index + var.private_subnet_count)
    availability_zone   = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]

    tags                = merge({ Name = "Private ${count.index}" }, var.private_subnet_tags)
}

resource "aws_route_table" "private_rt" {
    count                   = var.private_subnet_count

    vpc_id                  = var.vpc_id
}

resource "aws_route" "private_route" {
    count                   = var.private_subnet_count

    route_table_id          = aws_route_table.private_rt[count.index].id
    destination_cidr_block  = "0.0.0.0/0"

    nat_gateway_id = (
        var.multi_nat_gateway && (var.public_subnet_count >= var.private_subnet_count) ? aws_nat_gateway.ngw[count.index].id : (
            var.multi_nat_gateway && (var.private_subnet_count >= var.public_subnet_count) ? (
                count.index + 1 > length(aws_nat_gateway.ngw) ? aws_nat_gateway.ngw[count.index - length(aws_nat_gateway.ngw)].id : aws_nat_gateway.ngw[count.index].id
            ) : aws_nat_gateway.ngw[0].id
        ) 
    )
}

resource "aws_route_table_association" "private_route_join" {
    count                   = var.private_subnet_count

    route_table_id          = aws_route_table.private_rt[count.index].id
    subnet_id               = aws_subnet.private_subnet[count.index].id
}