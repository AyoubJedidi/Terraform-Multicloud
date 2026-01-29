# ============================================================
# PROVIDERS
# ============================================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Azure Provider (always configured)
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# AWS Provider - skip if not using
provider "aws" {
  region = var.aws_region
  
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  
  # Dummy credentials when not using AWS
  access_key = "mock"
  secret_key = "mock"
}

# GCP Provider - skip if not using
provider "google" {
  project = var.gcp_project != "" ? var.gcp_project : "dummy-project-12345"
  region  = var.gcp_region
  
  # Don't fail if credentials missing
  credentials = var.cloud_provider == "gcp" ? null : jsonencode({
    type = "service_account"
    project_id = "dummy-project-12345"
    private_key_id = "dummy"
    private_key = "-----BEGIN PRIVATE KEY-----\nMIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAwJZs\n-----END PRIVATE KEY-----\n"
    client_email = "dummy@dummy-project.iam.gserviceaccount.com"
    client_id = "123456789"
    auth_uri = "https://accounts.google.com/o/oauth2/auth"
    token_uri = "https://oauth2.googleapis.com/token"
  })
}
