# Pointer to the ISO images pool
resource "libvirt_pool" "iso" {
  name = "iso"
  type = "dir"
  path = var.libvirt_iso_path
}

# Pointer to the disk images pool
resource "libvirt_pool" "images" {
  name = "images"
  type = "dir"
  path = var.libvirt_disk_path
}

# Defining VM Volume
resource "libvirt_volume" "almacloud" {
  name   = "almacloud.qcow2"
  pool   = libvirt_pool.images
  source = var.libvirt_iso_path + var.alma_9_img
  format = "qcow2"
}

resource "libvirt_volume" "alma9-qcow2" {
  name           = "alma9.qcow2"
  base_volume_id = libvirt_volume.almacloud.id
  pool           = "default"
  size           = 10737418240
}

# Define KVM domain to create
resource "libvirt_domain" "Alma9" {
  name   = "Alma9"
  memory = "1024"
  vcpu   = 1

  network_interface {
    network_name = "default"            # List networks with virsh net-list
  }

  disk {
    volume_id = "${libvirt_volume.alma9-qcow2.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}

