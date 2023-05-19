# Output Server IP
output "ip" {
  value = "${libvirt_domain.Alma9.network_interface.0.addresses.0}"
}

