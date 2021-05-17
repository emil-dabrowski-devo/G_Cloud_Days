# G_Cloud_Days

This repo contains terraform scripts for Google Cloud Approaches Security workshop 1-2 June.

## Prerequesits

* Install Google Cloud SDK use [link](https://cloud.google.com/sdk/docs/install "SDK")
* Configure Google Cloud SDK using:
```
gcloud init
```

* Google Cloud Project for terraforming (adjust variable "terraform_project" - line 6 in terraform.tfvars file)
* Service Account in terraforming project with proper rights on the organization level (you can add rights on the folder level - check documentation and adjust terraform scriipt). You can create it using:
```
export SERVICE_ACCOUNT_ID=<<service account name e.g. terraform-sa>> 
export PROJECT_ID=<<Project id>>
export MEMBER=$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com
export ORGANIZATION_ID=<<use 'gcloud organizations list' to find organization ID>>
gcloud iam service-accounts create $SERVICE_ACCOUNT_ID --project $PROJECT_ID
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/compute.xpnAdmin'
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/orgpolicy.policyAdmin'
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/owner'
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/resourcemanager.folderAdmin'
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/resourcemanager.folderIamAdmin'
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/resourcemanager.projectIamAdmin'
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/resourcemanager.organizationViewer'
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member='serviceAccount:$MEMBER' --role='roles/resourcemanager.projectCreator'
```

* Create VM in terraform project or configure your envineronment to use terraform:
  * use service account: 
  ```
  gcloud iam service-accounts keys create terraform-sa.json --iam-account=$MEMBER
  export KEY_PATH=$(pwd)
  export KEY_FILE=$KEY_PATH/terraform-sa.json
  export GOOGLE_CREDENTIALS=$(cat $KEY_FILE | jq -c)
  ```
* Download and install Terraform - use [link](https://www.terraform.io/docs/cli/install/apt.html "Terraform")
* clone this repo: 
```
git clone https://github.com/emil-dabrowski-devo/G_Cloud_Days.git
cd G_Cloud_Days
```
* set variables in file terraform.tfvars (change required lines 1-4 and 6 if the terraform project id is different, rest parameters are optional) 
```
vim terraform.tfvars
```


## Step 1: Create resources (folders, projects, enable APIs)
* You need to copy resources tf files to the runner folder:
```
cd runner
cp ../resources/* .
```
you should copy two files: apis.tf and resources.tf

* now run:
```
terraform init
terraform plan -var-file="../terraform.tfvars"
terraform apply -var-file="../terraform.tfvars"
```
## Step 2: Create Organizational Policies
* You need to copy org-policies tf files to the runner folder:
```
cp ../org-policies/* .
```
you should copy one file: org-policies.tf

* now run:
```
terraform init
terraform plan -var-file="../terraform.tfvars"
terraform apply -var-file="../terraform.tfvars"
```
## Step 3: Create network
* You need to copy networking tf files to the runner folder:
```
cp ../networking/* .
```
you should copy two files: network.tf and firewall.tf

* now run:
```
terraform init
terraform plan -var-file="../terraform.tfvars"
terraform apply -var-file="../terraform.tfvars"
```
## Step 4: Create Cloud NAT 
* You need to copy nat tf files to the runner folder:
```
cp ../nat/* .
```
you should copy one file: nat.tf

* now run:
```
terraform init
terraform plan -var-file="../terraform.tfvars"
terraform apply -var-file="../terraform.tfvars"
```
## Step 5: Create virtual machines
* You need to copy vms tf files to the runner folder:
```
cp ../vms/* .
```
you should copy one file: compute.tf

* now run:
```
terraform init
terraform plan -var-file="../terraform.tfvars"
terraform apply -var-file="../terraform.tfvars"
```
## Step 6: Create firewall policies
* You need to copy allow-http tf files to the runner folder:
```
cp ../allow-http/* .
```
you should copy one file: allow-http.tf

* now run:
```
terraform init
terraform plan -var-file="../terraform.tfvars"
terraform apply -var-file="../terraform.tfvars"
```
## Step 7: Create Load Balancer
* You need to copy lb tf files to the runner folder:
```
cp ../lb/* .
```
you should copy one file: lb.tf

* now run:
```
terraform init
terraform plan -var-file="../terraform.tfvars"
terraform apply -var-file="../terraform.tfvars"
```
## Next Steps
Watch the recording to see how to use Cloud Armor, IAP, Logging and Monitoring, and SCC.
