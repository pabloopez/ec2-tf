#---- modules/iam/main.tf


resource "aws_iam_role" "s3_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "admin_policy_1" {
  name        = var.plc1_policy_name
  path        = var.plc1_path
  description = var.plc1_iam_policy_description
  policy      = var.plc1_iam_policy
}

resource "aws_iam_policy" "admin_policy_2" {
  name        = var.plc2_policy_name
  path        = var.plc2_path
  description = var.plc2_iam_policy_description
  policy      = var.plc2_iam_policy
}

resource "aws_iam_policy" "admin_policy_3" {
  name        = var.plc3_policy_name
  path        = var.plc3_path
  description = var.plc3_iam_policy_description
  policy      = var.plc3_iam_policy
}



resource "aws_iam_role_policy_attachment" "attachment_policy_1" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.admin_policy_1.arn
}

resource "aws_iam_role_policy_attachment" "attachment_policy_2" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.admin_policy_2.arn
}

resource "aws_iam_role_policy_attachment" "attachment_policy_3" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.admin_policy_3.arn
}


resource "aws_iam_instance_profile" "s3_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.s3_role.name
}
