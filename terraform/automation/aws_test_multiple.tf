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
      volume_size = 24
    }

    provisioner "file" {
      source = "./scripts/install_nf.sh"
      destination = "/tmp/install_nf.sh"
      connection {
        host = "${self.public_ip}"
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("/Users/lescai/.ssh/aws-unipv-test.pem")}"
      }
    }

    provisioner "remote-exec" {
      inline = [
        "cd /usr/bin",
        "chmod +x /tmp/*sh",
        "sudo /tmp/install_nf.sh"]
      connection {
        host = "${self.public_ip}"
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("/Users/lescai/.ssh/aws-unipv-test.pem")}"
      }
    }
}
