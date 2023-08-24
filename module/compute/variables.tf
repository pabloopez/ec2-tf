# ------- module/variables.tf
variable "ami" {
  description = "ami for our instance"
}

variable "instance_type" {
  description = "the instance type for our instance"
}
variable "tag_name" {
  description = "name of tag for our instance"
}
variable "sg" {
  description = "security group that allows public access via http/ssh"
}
variable "user_data" {
  description = "userdata that will install webserver bashscript"
}
variable "iam_instance_profile" {
  description = "iam instance profile for the ec2 instance"
}
