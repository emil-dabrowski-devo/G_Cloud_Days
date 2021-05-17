terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  // Configuration options
  // Use env var for credentials 
  // (export GOOGLE_CREDENTIALS=$(cat /Users/emildabrowski/metro/keys/metro-terraform-sa.json | jq -c))
}

provider "google-beta" {  
}
