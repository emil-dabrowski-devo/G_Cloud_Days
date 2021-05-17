# G_Cloud_Days

This repo contains terraform scripts for Google Cloud Approaches Security workshop 1-2 June.

## Prerequesits

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
* Download and install Terraform - use [link](https://www.terraform.io/downloads.html "Terraform")
* clone this repo: 
```
git clone 
```
