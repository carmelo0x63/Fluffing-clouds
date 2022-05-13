output "public_ip" {
  value       = aws_instance.t3-instance.public_ip
  description = "The public IP of the web server"
}
