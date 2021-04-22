provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "test01" {
    ami = "ami-00d35bd753513b01d"
    instance_type = "t2.medium"
    security_groups = [ "training-test-01" ]

    tags = {
      "name" = "test"
      "scope" = "training"
    }

    root_block_device {
      volume_size = 16
    }
}