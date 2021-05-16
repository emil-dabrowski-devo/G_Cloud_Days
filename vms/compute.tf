resource "google_service_account" "service_account_project" {
  for_each = var.service_projects
  project = each.key
  account_id   = "custom-service-account"
  display_name = "Custom Service Account for Compute Engine"
}

locals {
  compute_project = [
      for project in var.service_projects:
        project
  ]
}

resource "google_compute_instance" "web_app" {
  name         = "web-app"
  machine_type = "e2-small"
  zone         = "${var.region}-b"
  project      = local.compute_project[1]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-10-buster-v20210512"
    }
  }

  network_interface {
    subnetwork = "projects/${var.shared_vpc_project}/regions/${var.region}/subnetworks/${var.subnets[0]["subnet_name"]}"
    subnetwork_project = var.shared_vpc_project
  }

  metadata_startup_script = <<-EOT
            sudo apt-get update
            sudo apt-get install -yq nginx
            sudo mkdir /var/www/html/red
            sudo mkdir /var/www/html/green
            sudo gsutil cp gs://g-cloud-days-security/white.html /var/www/html/
            sudo gsutil cp gs://g-cloud-days-security/red.html /var/www/html/red
            sudo gsutil cp gs://g-cloud-days-security/green.html /var/www/html/green
            sudo service nginx restart
            EOT


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "custom-service-account@${local.compute_project[1]}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  depends_on = [module.cloud-nat]
}

resource "google_compute_instance" "test_instance" {
  name         = "test-instance"
  machine_type = "e2-small"
  zone         = "${var.region}-b"
  project      = local.compute_project[0]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-10-buster-v20210512"
    }
  }

  network_interface {
    subnetwork = "projects/${var.shared_vpc_project}/regions/${var.region}/subnetworks/${var.subnets[1]["subnet_name"]}"
    subnetwork_project = var.shared_vpc_project
  }

  metadata_startup_script = <<-EOT
            sudo apt-get update
            EOT


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "custom-service-account@${local.compute_project[0]}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  depends_on = [module.cloud-nat]
}