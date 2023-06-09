# Output the "list" of all availability domains.
output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "compartment-name" {
  value = oci_identity_compartment.CloudChallenge.name
}

#output "public-ip-x86_64-instances" {
#  value = oci_core_instance.vm_instance_x86_64.*.public_ip
#}

#output "public-ip-ampere-instance" {
#  value = oci_core_instance.vm_instance_ampere.*.public_ip
#}

# IP of OCI instance stored into a local file
resource "local_file" "ip" {
    content         = oci_core_instance.vm_instance_x86_64.0.public_ip
    filename        = "oci_remote_ip.txt"
    file_permission = "0644"
}

# SSH command line
output "SSH_CLI" {
  value = <<SSHCLIEOF
    Host IP  = ${oci_core_instance.vm_instance_x86_64.0.public_ip}
    User     = ${var.vm_user}
    Identity = ${var.ssh_private_key_path}
    Command  = ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.ssh_private_key_path} ${var.vm_user}@${oci_core_instance.vm_instance_x86_64.0.public_ip}
  SSHCLIEOF
}

