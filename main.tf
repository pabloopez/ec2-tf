terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.21"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1"
}

module "compute" {
  source               = "./module/compute"
  ami                  = "ami-06db4d78cb1d3bbf9"
  instance_type        = "m4.xlarge"
  tag_name             = "my_host"
  sg                   = module.security.webserver_sg
  user_data            = file("./scripts/userdata.tpl")
  iam_instance_profile = module.iam.s3_profile
  public_key_path      = "~/.ssh/my_sshkey.pub"
}

module "security" {
  source = "./module/security"
}

module "iam" {
  source                 = "./module/iam"
  role_name              = "s3-list-bucket"
  instance_profile_name  = "s3-list-bucket"
  assume_role_policy     = file("./policy/ec2-trusted-id.tpl")

  plc1_policy_name            = "s3-list-bucket"
  plc1_path                   = "/"
  plc1_iam_policy_description = "s3 policy for ec2 to list role"
  plc1_iam_policy             = file("./policy/s3-list-bucket-policy.tpl")

  plc2_policy_name            = "admin-read1"
  plc2_path                   = "/"
  plc2_iam_policy_description = "read1 access for admin users"
  plc2_iam_policy             = templatefile("./policy/plc-admin-read1-policy.tpl", { AWS_ACCOUNT_ID = var.AWS_ACCOUNT_ID})

  plc3_policy_name            = "admin-read2"
  plc3_path                   = "/"
  plc3_iam_policy_description = "read2 access for admin users"
  plc3_iam_policy             = templatefile("./policy/plc-admin-read2-policy.tpl", { AWS_ACCOUNT_ID = var.AWS_ACCOUNT_ID})
}

module "iam-admin" {
  source                 = "./module/iam"
  role_name              = "admin-read1"
  instance_profile_name  = "admin-read1"
  policy_name            = "admin-read1"
  path                   = "/"
  iam_policy_description = "read access for admin users"
  iam_policy             = templatefile("./policy/plc-admin-read1-policy.tpl", { AWS_ACCOUNT_ID = var.AWS_ACCOUNT_ID})
  assume_role_policy     = file("./policy/ec2-trusted-id.tpl")
}

module "s3" {
  source        = "./module/s3"
  bucket_name   = "tf-state-"
  object_key    = "LUIT"
  object_source = "/dev/null"
}