domain = "" #domain name - use 'gcloud organizations list' to check DISPLAY_NAME
domain_ids = [""] #organization ID - use 'gcloud organizations list' to check CUSTOMER_ID
org_id = "" #organization ID - use 'gcloud organizations list' to check organization ID
billing_account = "" #billing account ID - use 'gcloud alpha billing accounts list' to see available billings
region = "europe-central2" #region where all services will operate
terraform_project = "g-cloud-terraform" #project where terraform service account is located
service_projects = ["g-cloud-web-service","g-cloud-test-project"]
shared_vpc_project = "g-cloud-shared-vpc"
subnets = [
        {
            subnet_name           = "g-cloud-web-service",
            subnet_ip             = "10.192.1.0/24",
            subnet_region         = "europe-central2", #use the same region as in region variable
            subnet_private_access = "true",
            subnet_flow_logs      = "true",
            description           = "Subnet for g-cloud-web-service"
        },
        {
            subnet_name           = "g-cloud-test-project",
            subnet_ip             = "10.192.10.0/24",
            subnet_region         = "europe-central2", #use the same region as in region variable
            subnet_private_access = "true",
            subnet_flow_logs      = "true",
            description           = "Subnet for g-cloud-test-project"
        }
        ]