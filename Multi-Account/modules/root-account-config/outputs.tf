output "org_trail_bucket_id" {
    value = module.org_trail.org_trail_bucket_id
}

output "org_accounts" {
    value = data.aws_organizations_organization.org_accounts.accounts
}

/* TODO: Re-organize */
output "log_acc_id" {
    value = data.aws_organizations_organization.org_accounts.non_master_accounts[index(data.aws_organizations_organization.org_accounts.non_master_accounts.*.name, "logs")].id
}

output "sec_acc_id" {
    value = data.aws_organizations_organization.org_accounts.non_master_accounts[index(data.aws_organizations_organization.org_accounts.non_master_accounts.*.name, "sec")].id
}

output "shared_acc_id" {
    value = data.aws_organizations_organization.org_accounts.non_master_accounts[index(data.aws_organizations_organization.org_accounts.non_master_accounts.*.name, "shared")].id
}