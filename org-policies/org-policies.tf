#Org Policies settings
resource "google_folder_organization_policy" "appengine_disable_code_download" {
  folder     = "folders/${google_folder.root.folder_id}"
  constraint = "constraints/appengine.disableCodeDownload"

  boolean_policy {
    enforced = true
  }
}
resource "google_folder_organization_policy" "compute_disable_serial_port_access" {
  folder     = "folders/${google_folder.root.folder_id}"
  constraint = "constraints/compute.disableSerialPortAccess"

  boolean_policy {
    enforced = true
  }
}
resource "google_folder_organization_policy" "compute_skip_default_network_creation" {
  folder     = "folders/${google_folder.root.folder_id}"
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}
resource "google_folder_organization_policy" "compute_vm_external_ip_access" {
  folder     = "folders/${google_folder.root.folder_id}"
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    inherit_from_parent = false

    deny {
      all = true
    }
  }
}
resource "google_folder_organization_policy" "gcp_resource_locations" {
  folder     = "folders/${google_folder.root.folder_id}"
  constraint = "constraints/gcp.resourceLocations"

  list_policy {
    inherit_from_parent = false

    allow {
      values = [
                "is:eu",
                "in:europe-central2-locations"
      ]
    }
  }
}
resource "google_folder_organization_policy" "iam_allowed_policy_member_domains" {
  folder     = "folders/${google_folder.root.folder_id}"
  constraint = "constraints/iam.allowedPolicyMemberDomains"

  list_policy {
    inherit_from_parent = false

    allow {
      values = var.domain_ids
    }
  }
}

resource "google_folder_organization_policy" "iam_automatic_iam_grants_for_default_service_accounts" {
  folder     = "folders/${google_folder.root.folder_id}"
  constraint = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"

  boolean_policy {
    enforced = true
  }
}
