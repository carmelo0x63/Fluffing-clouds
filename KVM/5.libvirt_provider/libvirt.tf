# Defining VM Volume
resource "libvirt_volume" "almacloud" {
  name   = "almacloud.qcow2"
  pool   = "default"                    # List storage pools using virsh pool-list
  #source = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.2-20230513.x86_64.qcow2"
  source = "./AlmaLinux-9-GenericCloud-9.2-20230513.x86_64.qcow2"
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

