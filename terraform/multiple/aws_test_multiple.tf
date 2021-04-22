provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "test01" {
    count = var.instance_count
    ami = "ami-00d35bd753513b01d"
    instance_type = var.instance_type
    security_groups = [ "training-test-01" ]

    tags = {
      "name" = "test"
      "scope" = "training"
    }

    root_block_device {
      volume_size = 16
    }
}

variable "instance_count" {
  default = 4
}

variable "instance_type" {
  default = "t2.medium"
}

