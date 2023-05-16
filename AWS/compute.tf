// A single AWS instance
resource "aws_instance" "t3-instance" {
  ami                    = "ami-0889a44b331db0194"
  instance_type          = "t3.nano"
  key_name               = "aws-static-webserver"
  vpc_security_group_ids = [aws_security_group.s_group.id]

  tags = {
    Name = "t3-multipurpose"
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
      "sudo yum install -yq python3",
      "echo '[+] Python3 installed!'"
    ]
  }
}

