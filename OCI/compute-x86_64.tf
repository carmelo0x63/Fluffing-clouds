// A single OCI instance
resource "oci_core_instance" "vm_instance_x86_64" {
  count                               = 1
  availability_domain                 = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id                      = oci_identity_compartment.CloudChallenge.id
  shape                               = "VM.Standard.E2.1.Micro"
  display_name                        = join("", [var.vm_name, ".x86.", count.index + 1])
  preserve_boot_volume                = false
  is_pv_encryption_in_transit_enabled = true
  freeform_tags                       = var.tags

  #   lifecycle {
  #     prevent_destroy = true
  #   }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  source_details {
    source_id   = var.vm_image_ocid_x86_64
    source_type = "image"
  }

  availability_config {
    is_live_migration_preferred = true
  }

  create_vnic_details {
    assign_public_ip          = true
    subnet_id                 = oci_core_subnet.vcn-public-subnet.id
    assign_private_dns_record = true
    hostname_label            = join("", [var.vm_name, "0", count.index + 1])
    private_ip                = join(".", ["10", "0", "0", count.index + 101])
    nsg_ids                   = [oci_core_network_security_group.cloudchallenge-network-security-group.id]
    freeform_tags             = var.tags
  }

#  connection {
#    type        = "ssh"
#    user        = "ubuntu"
#    private_key = file(var.ssh_private_key_path)
#    host        = "oci_core_instance.vm_instance_x86_64.0.public_ip"
#    timeout     = "2m"
#  }

#  provisioner "remote-exec" {
#    inline = ["sudo apt update", "sudo apt install -y ansible", "echo '[+] Ansible installed!'"]
#    inline = ["sudo apt update", "echo '[+] Package list updated!'"]
#  }

#  provisioner "local-exec" {
#    command = "ansible-playbook -u ubuntu -i oci_remote_ip.txt --private-key 'var.ssh_private_key_path' ansible/playbook.yaml"
#  }

#  provisioner "file" {
#    source      = "./ansible/playbook.yaml"
#    destination = "/home/ubuntu/playbook.yaml"
#  }
}

