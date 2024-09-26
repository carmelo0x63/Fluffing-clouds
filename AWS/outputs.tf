output "public_ip" {
  value       = aws_instance.t2u-free-instance.public_ip
  description = "Public IP of the web server"
}

# AWS instance IP stored into a local file
resource "local_file" "ip" {
  content         = aws_instance.t2u-free-instance.public_ip
  filename        = "aws_remote_ip.txt"
  file_permission = "0644"
}

