/* 
 * Create groups in identity account 
 */
 
resource "aws_iam_group" "group" {
    name                    = var.name
}

/* TODO: Make once? */
data "aws_iam_policy_document" "raw_policy" {
    version                 = "2012-10-17"
    statement {
        sid                 = "AssumeCrossAccountRoles"
        effect              = "Allow"
        actions             = ["sts:AssumeRole"]
        resources           = var.role_arns
    }
}

resource "aws_iam_group_policy" "group-policy" {
    policy                  = data.aws_iam_policy_document.raw_policy.json
    group                   = aws_iam_group.group.name
}