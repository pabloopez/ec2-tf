# ------- module/main.tf
resource "aws_key_pair" "my_ec2_key" {
  key_name   = "my-ec2-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "app_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg]
  user_data              = var.user_data
  iam_instance_profile   = var.iam_instance_profile
  key_name = aws_key_pair.my_ec2_key.key_name
  tags = {
    Name = "${var.tag_name}instance"
  }
}

