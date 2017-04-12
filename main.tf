#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-eea9f38e
#
# Your subnet ID is:
#
#     subnet-7e08481a
#
# Your security group ID is:
#
#     sg-834d35e4
#
# Your Identity is:
#
#     autodesk-turkey
#
#module "hello" {
#  source = "./example-module"
#  command = "echo LOL"
#}

variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-west-1"
}

terraform {
  backend "atlas" {
    name = "lmok/training"
  }
}

variable web_count {
  default = "2"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "web" {
  count                  = "${var.web_count}"
  ami                    = "ami-eea9f38e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-834d35e4"]
  subnet_id              = "subnet-7e08481a"

  tags {
    Identity = "autodesk-turkey"
    family   = "adsk"
    product  = "adsk"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
