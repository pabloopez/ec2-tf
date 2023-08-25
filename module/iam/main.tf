#---- modules/iam/main.tf


resource "aws_iam_role" "s3_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "s3_policy" {
  name        = var.policy_name
  path        = var.path
  description = var.iam_policy_description
  policy      = var.iam_policy
}

# resource "aws_iam_policy" "admin_read1" {
#   name        = var.policy_name
#   path        = var.path
#   description = var.iam_policy_description
#   policy      = var.iam_policy
# }

# resource "aws_iam_policy" "admin_read2" {
#   name        = var.policy_name
#   path        = var.path
#   description = var.iam_policy_description
#   policy      = var.iam_policy
# }

# resource "aws_iam_policy" "users_and_keys" {
#   name        = var.policy_name
#   path        = var.path
#   description = var.iam_policy_description
#   policy      = var.iam_policy
# }

resource "aws_iam_role_policy_attachment" "s3_attachment" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}
resource "aws_iam_instance_profile" "s3_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.s3_role.name
}
