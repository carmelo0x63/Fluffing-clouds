provider "libvirt" {
  # Configuration options
  alias = "darkstar"
  uri   = "qemu:///system"
#  uri   = "qemu+ssh://var.admin_user@192.0.2.40/system"
}

