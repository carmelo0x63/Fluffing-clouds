// A single AWS instance
resource "aws_instance" "t3-instance" {
  ami                    = "ami-048e6f7223041530b"
  instance_type          = "t3.micro"
  key_name               = "aws-static-webserver"
  vpc_security_group_ids = [aws_security_group.s_group.id]

  tags = {
    Name = "t3u-git-python3"
#    Name = "aws-web-${random_id.instance_id.hex}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key)
    host        = aws_instance.t3-instance.public_ip
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install -yq git python3",
      "echo '[+] Git, Python3 installed!'"
    ]
  }
}

