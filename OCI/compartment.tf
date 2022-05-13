resource "oci_identity_compartment" "CloudChallenge" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for lab resources."
  name           = var.compartment_name
  freeform_tags  = var.tags
  # enable_delete: If set to true, the provider will throw an error on a name collision with another compartment, and will attempt to delete the compartment on destroy or removal of the resource declaration. Default = false.
  #  enable_delete  = true
}

