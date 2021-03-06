/* Access log account for administration by assuming the organization created role in child account */

provider "aws" {
    region                  = "us-east-2"

    assume_role {
        role_arn            = "arn:aws:iam::${var.log_acc_id}:role/OrganizationAccountAccessRole"
        session_name        = "Terraform_Access_For_Log_Account_Provisions"
    }
}