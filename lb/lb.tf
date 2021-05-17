resource "google_compute_firewall" "allow-lb" {
  name    = "allow-lb"
  project = var.shared_vpc_project
  network = module.vpc.network_name
  direction = "INGRESS"
  priority = 1000
  source_ranges = [ "130.211.0.0/22","35.191.0.0/16" ]
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
}

resource "google_compute_instance_group" "web_app" {
  name        = "web-app"
  description = "Web-app unmanaged instance group"
  zone        = "${var.region}-b"
  project     = local.compute_project[1]
  instances = [google_compute_instance.web_app.id]
  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_managed_ssl_certificate" "cloud_days" {
  name = "web-app-cert"
  project = local.compute_project[1]

  managed {
    domains = ["cloud-days.appsdemo.se."]
  }
}

module "gce-lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 4.4"

  project           = local.compute_project[1]
  name              = "web-app-http-lb"
  firewall_projects = [var.shared_vpc_project]
  firewall_networks = [module.vpc.network_name]
  ssl                  = true
  ssl_certificates     = [google_compute_managed_ssl_certificate.cloud_days.self_link]
  use_ssl_certificates = true
  create_url_map    = false
  http_forward      = false



  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = "80"
      port_name                       = "http"
      timeout_sec                     = 10
      enable_cdn                      = false
      custom_request_headers          = null
      security_policy                 = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = "80"
        host                = null
        logging             = null
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = google_compute_instance_group.web_app.self_link
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}