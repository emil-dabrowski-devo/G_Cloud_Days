#create shared vpc network
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.0"
    project_id   = var.shared_vpc_project
    network_name = "shared-network"
    routing_mode = "REGIONAL"
    subnets = var.subnets
    depends_on = [google_project.shared]
}

#create vpc access connector in europe-central1
resource "google_vpc_access_connector" "connector_eu_central2" {
  project       = var.shared_vpc_project
  name          = "g-cloud-eu-central2"
  region        = "europe-central2"
  ip_cidr_range = var.vpc_connector_cidr[0]
  network       = module.vpc.network_name
  min_throughput = 200
  max_throughput = 1000
  depends_on = [google_project_service.shared_vpc_apis, google_project.shared]
}

#enable shared vpc service in shared vpc project
resource "google_compute_shared_vpc_host_project" "host_project" {
  project = google_project.shared.name
}

#enable service projects to use shared vpc
resource "google_compute_shared_vpc_service_project" "shared_vpc" {
  for_each = var.service_projects
  host_project    = google_compute_shared_vpc_host_project.host_project.project
  service_project = each.key
}
locals {
  subnets_list = [
      for s in module.vpc.subnets:
        s.id
  ]
}

#grant access for default service accounts to use shared vpc
module "shared_vpc_access" {
  for_each            = var.service_projects
  source              = "terraform-google-modules/project-factory/google//modules/shared_vpc_access"
  host_project_id     = var.shared_vpc_project
  service_project_id  = each.key
  enable_shared_vpc_service_project = true
  grant_services_security_admin_role = true
  active_apis         = [
    "compute.googleapis.com"
  ]
  shared_vpc_subnets  = local.subnets_list
  depends_on = [google_compute_shared_vpc_host_project.host_project, module.project-services]
}
