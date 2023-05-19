variable "qemu_uri" {
  description = "QEMU URI"
  type        = string
}

variable "admin_user" {
  description = "Libvirt user"
  type        = string
}

variable "libvirt_iso_path" {
  description = "Path to libvirt ISO images"
  type        = string
  default     = "/var/lib/libvirt/images"
}

variable "libvirt_disk_path" {
  description = "Path to libvirt disk images"
  type        = string
  default     = "/var/lib/libvirt/images2"
}

variable "alma_9_img" {
  description = "AlmaLinux 9.x cloud image"
  type        = string
}

