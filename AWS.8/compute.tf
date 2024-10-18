// A single AWS instance
resource "aws_instance" "g4dn-instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "aws-generic-server"
  vpc_security_group_ids = [aws_security_group.s_group.id]

  root_block_device {
    volume_size = 120
  }

#  ebs_block_device {
#    device_name = "/dev/sda1"
#    volume_size = 24
#  }

  tags = {
    Name   = "Ollama"
#    Name = "aws-web-${random_id.instance_id.hex}"
    GPU    = "Yes"
    Git    = "Yes"
    Docker = "Yes"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key)
    host        = aws_instance.g4dn-instance.public_ip
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -yq docker git",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl enable --now docker",
      "sudo curl -L 'https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "echo '[+] Docker, Git installed!' > install_log.txt"
    ]
  }
}

