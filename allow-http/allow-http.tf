resource "google_compute_firewall" "allow_internal_http" {
  name    = "allow-internal-http"
  project = var.shared_vpc_project
  network = module.vpc.network_name
  direction = "INGRESS"
  priority = 1000
  source_service_accounts = ["custom-service-account@${local.compute_project[0]}.iam.gserviceaccount.com"]
  target_service_accounts = ["custom-service-account@${local.compute_project[1]}.iam.gserviceaccount.com"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  allow {
    protocol = "icmp"
  }
}