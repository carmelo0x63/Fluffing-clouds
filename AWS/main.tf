// Configure the provider: AWS
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 6
}

// A single AWS instance
resource "aws_instance" "t3-instance" {
  ami                    = "ami-0ed21bdc9c547dd9b"
  instance_type          = "t3.micro"
  key_name               = "aws-static-webserver"
#  key_name               = "aws-web-${random_id.instance_id.hex}"
  vpc_security_group_ids = [aws_security_group.s_group.id]

  tags = {
    Name = "t3-multipurpose"
#    Name = "aws-web-${random_id.instance_id.hex}"
  }

  provisioner "remote-exec" {
#    inline = ["sudo apt-get -qq install python -y"]
    inline = [
      "sudo yum install -yq python3"
    ]
  }

  connection {
    user        = "ec2-user"
    host        = aws_instance.t3-instance.public_ip
    private_key = file(var.private_key)
  }
}

resource "aws_security_group" "s_group" {
  name = "terraform-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_key_pair" "ssh-keypair" {
  key_name   = "aws-static-webserver"
  public_key = file(var.public_key)
}

