# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_fault_domains" "FDs" {
    #Required
    availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
    compartment_id = var.compartment_ocid
}


# Gets a list of vNIC attachments on the bastion host
data "oci_core_vnic_attachments" "BastionVnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  instance_id         = oci_core_instance.BastionHost.id
}

# Gets the OCID of the first vNIC on the bastion host
data "oci_core_vnic" "BastionVnic" {
  vnic_id = data.oci_core_vnic_attachments.BastionVnics.vnic_attachments[0]["vnic_id"]
}

# Get the Private of bastion host
data "oci_core_private_ips" "BastionPrivateIPs" {
  ip_address = data.oci_core_vnic.BastionVnic.private_ip_address
  subnet_id  = oci_core_subnet.BastionSubnetAD1.id
}

# Gets the Id of a specific OS Images
data "oci_core_images" "InstanceImageOCID" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.OsImage
}
