data "aws_ami" "openvpn" {
    owners          = ["aws-marketplace"]
    most_recent     = true

    filter {
        name    = "name"
        values  = ["OpenVPN Access Server 2.7.5*"]
    }
}