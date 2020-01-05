resource "aws_iam_role_policy" "ssm_management" {
  name = "proec2SsmManagement"
  role = module.iam-role.role_id
  policy = templatefile("${path.module}/templates/ssm_policy.tpl",{})
}

resource "aws_iam_role_policy" "s3_management" {
  name = "proec2S3Management"
  role = module.iam-role.role_id
  policy = templatefile("${path.module}/templates/s3_policy.tpl",{
    s3_bucket_arn = aws_s3_bucket.test.arn
  })
}

resource "aws_key_pair" "ec2" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDs8isKqXy92kp3YWYmJg7FK7Jk0bKAGbG79tHVArh4XRi7kMK7bM40NHIn3c74jZwDHN5zOV2eJumWRhL0KmdnFcoA30XtRA/gjWvfQf+xoPN1mOh7egTVA9EIvl4alxZ3Oaqk8Ls+rELjLXfa8WmWJ1uOMw3uP7/r4CeCVKhImrt+B4hwimebJze+fltSiVqNf+g3F80Be90xREQBf3svS23A9MGxLXcnAMv/n8JpalzVDvBzbDowHyy11zaTAZBtzAAI/8JVR9dKBytQkW3N/7rTSB6Q5XxvzUELwDNsEczDtq6/7gXnYwyz5qW/Uw+0a+ZmW+9kopYNBk7NXz4P"
}

module "iam-role" {
  source        = "github.com/felipem1210/tf-aws-iam-role-common.git"
  iam_role_name = "s3-files-download"
}

resource "aws_iam_instance_profile" "myprofile" {
    name = "ec2_profile"
  role = module.iam-role.role_name
}

module "ec2-linux" {
  source = "github.com/felipem1210/terraform-aws-ec2-instance.git"
  #source = "./ec2-no-elb"
  name                   = "ec2-test"
  associate_public_ip_address = true
  ami                    = "ami-038a2f73ad495e99e"
  instance_type          = "t2.micro"
  key_name               = "deployer-key"
  iam_instance_profile   = aws_iam_instance_profile.myprofile.name
  subnet_ids              = module.networking.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.http_allow_traffic.id]
  tags = {
    Name   = "flugel"
    Environment = "dev"
    prefix      = "test"
  }
}

resource "aws_security_group" "http_allow_traffic" {
  name        = "allow_http"
  description = "Allow http inbound traffic to ec2 instance"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 54000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name   = "flugel"
    Environment = "dev"
    prefix      = "test"
  }
}