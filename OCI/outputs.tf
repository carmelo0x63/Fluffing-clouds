# Output the "list" of all availability domains.
output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "compartment-name" {
  value = oci_identity_compartment.CloudChallenge.name
}

output "public-ip-x86_64-instances" {
  value = oci_core_instance.vm_instance_x86_64.*.public_ip
}

#output "public-ip-ampere-instance" {
#  value = oci_core_instance.vm_instance_ampere.*.public_ip
#}

# IP of OCI instance stored into a local file
resource "local_file" "ip" {
    content         = oci_core_instance.vm_instance_x86_64.0.public_ip
    filename        = "remote_ip.txt"
    file_permission = "0644"
}

