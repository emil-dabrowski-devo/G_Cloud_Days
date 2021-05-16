#create Cloud router for NAT
resource "google_compute_router" "router" {
  name = "nat-router"
  network = module.vpc.network_name
  region = var.region
  project = var.shared_vpc_project
}

#create NAT for accessing extternal resources
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.shared_vpc_project
  region     = var.region
  router     = google_compute_router.router.name
}