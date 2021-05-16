#firewall rule that grands SSH and RDP access thorugh Identity Aware Proxy 
resource "google_compute_firewall" "allow-iap" {
  name    = "allow-iap"
  project = var.shared_vpc_project
  network = module.vpc.network_name
  direction = "INGRESS"
  priority = 1
  source_ranges = [ "35.235.240.0/20" ]
  allow {
    protocol = "tcp"
  }
}

#firEewall rule that allows accessing from serverless to vpc
resource "google_compute_firewall" "serverless_to_vpc_connector" {
  name    = "serverless-to-vpc-connector"
  project = var.shared_vpc_project
  network = module.vpc.network_name
  direction = "INGRESS"
  priority = 1000
  source_ranges = [ "107.178.230.64/26", "35.199.224.0/19" ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }

  allow {
    protocol ="udp"
    ports = [ "665", "666" ]
  }

  target_tags = ["vpc-connector"]
}

#firEewall rule that allows accessing from vpc to serverless
resource "google_compute_firewall" "vpc_connector_to_serverless" {
  name    = "vpc-connector-to-serverless"
  project = var.shared_vpc_project
  network = module.vpc.network_name
  direction = "EGRESS"
  priority = 1000
  destination_ranges = [ "107.178.230.64/26", "35.199.224.0/19" ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }

  allow {
    protocol ="udp"
    ports = [ "665", "666" ]
  }

  target_tags = ["vpc-connector"]
}

#firewall rule that allows to use healtth-check in serverless
resource "google_compute_firewall" "vpc-connector-health-checks" {
  name    = "vpc-connector-health-checks"
  project = var.shared_vpc_project
  network = module.vpc.network_name
  direction = "INGRESS"
  priority = 1000
  source_ranges = [ "130.211.0.0/22", "35.191.0.0/16", "108.170.220.0/23" ]

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }

  target_tags = ["vpc-connector"]
}