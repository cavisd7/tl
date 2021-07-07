data "aws_ami" "openvpn" {
    owners          = ["aws-marketplace"]
    most_recent     = true

    filter {
        name    = "name"
        values  = ["OpenVPN Access Server 2.7.5*"]
    }
}

resource "aws_security_group" "vpn" {
    name        = "OpenVPN-sg"
    description = "OpenVPN required ports"
    vpc_id      = var.vpc_id

    ingress {
        description      = "SSH from trusted IPs"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = var.admin_ips
    }

    ingress {
        description      = "Admin Web UI"
        from_port        = 943
        to_port          = 943
        protocol         = "tcp"
        cidr_blocks      = var.admin_ips
    }

    /*ingress {
        description      = "Clustering"
        from_port        = 945
        to_port          = 945
        protocol         = "tcp"
        cidr_blocks      = 
    }*/

    ingress {
        description      = "Client Access"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = var.client_ips
    }

    ingress {
        description      = "UDP Client Access"
        from_port        = 1194
        to_port          = 1194
        protocol         = "udp"
        cidr_blocks      = var.client_ips
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "VPN"
    }
}

data "aws_iam_policy_document" "lets_encrypt" {
    statement {
        sid = "Route53Read"
        resources = ["*"]
        effect = "Allow"
        actions = [
            "route53:ListHostedZones",
            "route53:GetChange"
        ]
    }

    /*statement {
        sid         = "Route53ModifyRecordSets"
        resources   = [ "arn:aws:route53:::hostedzone/${var.hosted_zone_id}" ]
        effect      = "Allow"
        actions     = [ "route53:ChangeResourceRecordSets" ]
    }*/
}

resource "aws_iam_role" "vpn" {
    name = "OpenVPNAdmin"
    description = ""

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AssumableByEC2",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF

    inline_policy {
        name = "Route53LetsEncrypt"
        policy = data.aws_iam_policy_document.lets_encrypt.json
    }
}

resource "aws_iam_instance_profile" "vpn" {
    name = "VPN"
    role = aws_iam_role.vpn.name
}

resource "aws_launch_template" "vpn" {
    name_prefix     = "vpn"
    image_id        = data.aws_ami.openvpn.id
    instance_type   = "t2.micro"

    network_interfaces {
        security_groups             = [ aws_security_group.vpn.id ] 
        associate_public_ip_address = true
    }

    user_data       = filebase64("scripts/00_openvpn_config.sh") 

    iam_instance_profile {
        arn = aws_iam_instance_profile.vpn.arn
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            "Name" = "VPN"
        }
    }
}

resource "aws_autoscaling_group" "vpn" {
    vpc_zone_identifier = var.public_subnets
    force_delete        = var.should_cleanup

    desired_capacity    = var.desired_capacity
    max_size            = var.desired_capacity + 1
    min_size            = (var.desired_capacity - 1) <= 0 ? 1 : var.desired_capacity - 1

    launch_template {
        id      = aws_launch_template.vpn.id
        version = "$Latest"
    }
}

/*data "aws_instances" "vpns" {
    filter {
        name   = "tag:Name"
        values = ["VPN"]
    }

    depends_on = [ aws_autoscaling_group.vpn ]
}

resource "aws_eip" "vpn" {
    count = var.desired_capacity

    instance = data.aws_instances.vpns.ids[count.index]
    vpc      = true
}*/