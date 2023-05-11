// A single AWS instance
resource "aws_instance" "t3-instance" {
  ami                    = "ami-0889a44b331db0194"
  instance_type          = "t3.nano"
  key_name               = "aws-static-webserver"
#  key_name               = "aws-web-${random_id.instance_id.hex}"
  vpc_security_group_ids = [aws_security_group.s_group.id]

  tags = {
    Name = "t3-multipurpose"
#    Name = "aws-web-${random_id.instance_id.hex}"
  }

  provisioner "remote-exec" {
#    inline = ["sudo apt -qq install python -y"]
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

