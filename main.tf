terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "my_ssh_key"
  create_private_key = true
}

module "compute" {
  source               = "./module/compute"
  ami                  = "ami-06db4d78cb1d3bbf9"
  instance_type        = "m4.xlarge"
  tag_name             = "my_host"
  sg                   = module.security.webserver_sg
  user_data            = file("./userdata.tpl")
  iam_instance_profile = module.iam.s3_profile
}

module "security" {
  source = "./module/security"
}

module "iam" {
  source                 = "./module/iam"
  role_name              = "s3-list-bucket"
  policy_name            = "s3-list-bucket"
  instance_profile_name  = "s3-list-bucket"
  path                   = "/"
  iam_policy_description = "s3 policy for ec2 to list role"
  iam_policy             = file("./s3-list-bucket-policy.tpl")
  assume_role_policy     = file("./s3-list-bucket-trusted-identity.tpl")
}
module "s3" {
  source        = "./module/s3"
  bucket_name   = "devinslevelupintechbucket0223"
  acl           = "private"
  object_key    = "LUIT"
  object_source = "/dev/null"
}

# we need to run:
# ssh-keygen -t rsa -b 4096