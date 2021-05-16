#enable all necessary APIs in terraforming project
module "terraform-project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  project_id = var.terraform_project
  activate_apis = var.services_terraform_project
}

#enable all necessary APIs in shared vpc project
resource "google_project_service" "shared_vpc_apis" {
  for_each = var.services_host_project
  project = var.shared_vpc_project
  service = each.key
  disable_dependent_services = false
  disable_on_destroy = false
  depends_on = [google_project.shared]
}

#enable all necessary APIs in service projeccts
module "project-services" {
  for_each = var.service_projects
  source  = "terraform-google-modules/project-factory/google//modules/project_services"

  project_id = each.key
  activate_apis = var.services_service_project
  depends_on = [google_project.services]
}