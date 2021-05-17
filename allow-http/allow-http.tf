# resource "google_compute_firewall" "allow_internal_http" {
#   name    = "allow-internal-http"
#   project = var.shared_vpc_project
#   network = module.vpc.network_name
#   direction = "INGRESS"
#   priority = 1000
#   source_service_accounts = ["custom-service-account@${local.compute_project[0]}.iam.gserviceaccount.com"]
#   target_service_accounts = ["custom-service-account@${local.compute_project[1]}.iam.gserviceaccount.com"]
#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }
#   allow {
#     protocol = "icmp"
#   }
# }

resource "google_compute_organization_security_policy" "fw_policy" {
  provider = google-beta

  display_name = "allow-http"
  parent       = google_folder.root.id
}

resource "google_compute_organization_security_policy_rule" "policy" {
  provider = google-beta

  policy_id = google_compute_organization_security_policy.fw_policy.id
  action = "allow"

  direction = "INGRESS"
  enable_logging = true
  match {
    config {
      src_ip_ranges = ["10.0.0.0/8"]
      target_service_accounts = ["custom-service-account@${local.compute_project[1]}.iam.gserviceaccount.com"]
      layer4_config {
        ip_protocol = "tcp"
        ports = ["80"]
      }
      layer4_config {
        ip_protocol = "icmp"
      }
    }
  }
  priority = 100
}

resource "google_compute_organization_security_policy_association" "http-policy" {
  provider = google-beta

  name          = "http-policy"
  attachment_id = google_compute_organization_security_policy.fw_policy.parent
  policy_id     = google_compute_organization_security_policy.fw_policy.id
}