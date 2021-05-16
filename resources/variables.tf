variable "domain" {
  description = "Google Domain Name"
  default = ""
}

variable "domain_ids" {
  description = "Google Domain IDs"
  default = []
}

variable "org_id" {
  description = "Organization ID"
  default = ""
}
variable "billing_account" {
  description = "Billing ID"
  default = ""
}

variable "region" {
  description = "Terraform tf state region"
  default = ""
}

variable "terraform_project" {
  description = "Terraforming project name"
  default = ""
}

variable "service_projects" {
  description = "List of service projects"
  type = set(string)
  default = []
}

variable "shared_vpc_project" {
  description = "Shared VPC project id"
  default = ""
}

variable "services_service_project" {
  description = "APIs that should be enabled in service projects"
  default = ["vpcaccess.googleapis.com","compute.googleapis.com"]
}

variable "services_host_project" {
  description = "APIs that should be enabled in Shared VPC project"
  type = set(string)
  default = ["vpcaccess.googleapis.com","compute.googleapis.com"]
}

variable "services_terraform_project" {
  description = "APIs that should be enabled in Terraforming project"
  type = set(string)
  default = ["cloudbilling.googleapis.com", "admin.googleapis.com", "cloudidentity.googleapis.com","iam.googleapis.com"]
}

variable "vpc_connector_cidr" {
  description = "VPC Connector CIDRs (Cloud Functions connector)"
  default = ["10.192.253.0/28"]
}

variable "subnets" {
  description = "Subnets for projects"
  default = []
}