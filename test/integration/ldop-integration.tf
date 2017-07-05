# Providers

provider "aws" {
  region = "us-west-2"
}

# Resources

resource "aws_security_group" "test_env" {
  name = "terraform_test_env"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "test_key" {
  key_name = "terraform-ldop"
  public_key = "${file("${path.module}/terraform.key.pub")}"
}

resource "aws_instance" "test_env" {
  instance_type          = "t2.large"
  key_name               = "${aws_key_pair.test_key.key_name}"
  ami                    = "ami-6df1e514"
  vpc_security_group_ids = ["${aws_security_group.test_env.id}"]

  root_block_device {
    volume_size = 16
  }

  # Install docker, docker-compose and git
  provisioner "remote-exec" {
    connection {
      user        = "ec2-user"
      private_key = "${file("${path.module}/terraform.key")}"
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user",
      "sudo pip install docker-compose && sudo cp /usr/local/bin/docker-compose /usr/bin/",
      "sudo yum install -y git",
    ]
  }

  # Clone ldop-docker-compose repo 
  provisioner "remote-exec" {
    connection {
      user        = "ec2-user"
      private_key = "${file("${path.module}/terraform.key")}"
    }

    inline = [
      "git clone https://github.com/liatrio/ldop-docker-compose.git",
    ]
  }

  # Copy new docker-compose file
  provisioner "file" {
    connection {
      user        = "ec2-user"
      private_key = "${file("${path.module}/terraform.key")}"
    }

    source      = "${path.module}/docker-compose.yml"
    destination = "~/ldop-docker-compose/docker-compose.yml"
  }

  # Copy test secrets file
  provisioner "file" {
    connection {
      user        = "ec2-user"
      private_key = "${file("${path.module}/terraform.key")}"
    }

    source      = "${path.module}/platform.secrets.sh"
    destination = "~/ldop-docker-compose/platform.secrets.sh"
  }

  # Run integration test
  provisioner "remote-exec" {
    connection {
      user        = "ec2-user"
      private_key = "${file("${path.module}/terraform.key")}"
    }

    inline = [
      "cd ~/ldop-docker-compose",
      "sudo ./adop compose init", # Also creates certs
      "./adop compose down --volumes",
      "./adop test basic",
    ]
  }
}
