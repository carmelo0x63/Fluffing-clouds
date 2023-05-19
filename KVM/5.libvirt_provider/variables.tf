variable "qemu_uri" {
  description = "QEMU URI"
  type        = string
}

variable "admin_user" {
  description = "Libvirt user"
  type        = string
}

variable "libvirt_downloads_path" {
  description = "Path to libvirt Cloud images"
  type        = string
#  default     = "/var/lib/libvirt/images"
  default     = "./downloads"
}

variable "libvirt_disk_path" {
  description = "Path to libvirt disk images"
  type        = string
#  default     = "/var/lib/libvirt/images2"
  default     = "./images"
}

variable "alma9_img" {
  description = "AlmaLinux 9.x cloud image"
  type        = string
}

