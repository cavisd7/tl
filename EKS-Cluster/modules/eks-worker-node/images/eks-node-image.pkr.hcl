variable "region" {
    type    = string
    default = "us-east-2"
}

variable "aws_profile" {
    type    = string
    default = "default"
}

variable "version" {
    type    = string
    default = "1.19"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "eks-image" {
  ami_name          = "eks-worker-node-${local.timestamp}"
  ami_description   = "EKS-optimized AMI for worker node of EKS cluster."
  instance_type     = "t2.micro"
  region            = var.region
  profile           = var.aws_profile

  source_ami_filter {
        filters = {
            virtualization-type   = "hvm"
            architecture          = "x86_64"
            name                  = "amazon-eks-node-${var.version}-v*"
            root-device-type      = "ebs"
            state                 = "available"
        }
        most_recent = true
        owners      = ["602401143452"]
    }
    ssh_username = "ec2-user"
}

build {
    sources = ["source.amazon-ebs.eks-image"]

    provisioner "shell" {
        script = "./setup.sh"
    }
}

