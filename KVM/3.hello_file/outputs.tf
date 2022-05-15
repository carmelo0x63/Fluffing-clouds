output "text" {
  value = file("${path.module}/${var.filename}")
}

