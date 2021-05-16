// Folders
# Top-level folders under the organization.
resource "google_folder" "root" {
  display_name = "g-cloud-days"
  parent       = "organizations/${var.org_id}"
}

# Folders nested each environment folder.
resource "google_folder" "shared"{
  display_name = "shared"
  parent       = google_folder.root.name
}

resource "google_folder" "services"{
  display_name = "services"
  parent       = google_folder.root.name
}

# Folder Production
resource "google_project" "services" {
  for_each            = var.service_projects
  auto_create_network = false
  name                = each.key
  project_id          = each.key
  folder_id           = google_folder.services.name
  billing_account     = var.billing_account
  depends_on = [module.terraform-project-services]
}

# Folder Shared
resource "google_project" "shared" {
  auto_create_network = false
  name                = var.shared_vpc_project
  project_id          = var.shared_vpc_project
  folder_id           = google_folder.shared.name
  billing_account     = var.billing_account
  depends_on = [module.terraform-project-services]
}
