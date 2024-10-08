// A single AWS instance
resource "aws_instance" "t2u-free-instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "aws-generic-server"
  vpc_security_group_ids = [aws_security_group.s_group.id]

#  root_block_device {
#    volume_size = 16
#  }

#  ebs_block_device {
#    device_name = "/dev/sda1"
#    volume_size = 24
#  }

  tags = {
    Name = "t2u-git-python3"
#    Name = "aws-web-${random_id.instance_id.hex}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key)
    host        = aws_instance.t2u-free-instance.public_ip
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install -yq git python3",
      "echo '[+] Git, Python3 installed!' > install_log.txt"
    ]
  }
}

