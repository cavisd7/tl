/*
 * Root Account Configuration
 */

module "root_acc_config" {
    source                                          = "./modules/root-account-config"

    child_accounts                                  = var.child_accounts
    org_trail_bucket_name                           = var.org_trail_bucket_name

    org_cloudtrail_key_arn                          = module.log_acc_config.org_cloudtrail_key_arn
}

/*
 * Log Account Configuration
 */

module "log_acc_config" {
    source                                          = "./modules/logs-account-config"

    log_acc_roles                                   = var.log_acc_roles
    org_trail_bucket_id                             = module.root_acc_config.org_trail_bucket_id
    log_acc_id                                      = module.root_acc_config.log_acc_id
    sec_acc_id                                      = module.root_acc_config.sec_acc_id

    acc_ids                                         = module.root_acc_config.org_accounts.*.id
}

/*
 * Identity Account Configuration
 */

/*module "identity_acc_config" {
    source                                          = "./modules/identity-account-config"

    sec_acc_id                                      = module.root_acc_config.sec_acc_id
    org_trail_bucket_id                             = module.root_acc_config.org_trail_bucket_id
    groups                                          = var.iam_groups
    users                                           = var.iam_users
    org_cloudtrail_key_arn                          = module.log_acc_config.org_cloudtrail_key_arn
}*/