# ============================================================
# PROVIDERS.TF
# ============================================================
# PURPOSE: Configure cloud provider connections
#
# WHAT IT DOES:
# 1. Tells Terraform which cloud APIs to use
# 2. Sets minimum versions for compatibility
# 3. Configures authentication to each cloud
#
# WHEN CHANGED: Run `terraform init` to download providers
# ============================================================

terraform {
  required_version = ">= 1.0"
  
  # Cloud provider plugins
  required_providers {
    # Azure Provider
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Any 3.x version
    }
    
    # AWS Provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Any 5.x version
    }
    
    # GCP Provider
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"  # Any 5.x version
    }
  }
}

# ============================================================
# AZURE CONFIGURATION
# ============================================================
# Authenticates using Azure CLI (az login)
# If running in Jenkins, use service principal
provider "azurerm" {
  features {}  # Required block for Azure
}

# ============================================================
# AWS CONFIGURATION
# ============================================================
# Authenticates using AWS credentials (~/.aws/credentials)
# Region comes from var.aws_region
provider "aws" {
  region = var.aws_region
}

# ============================================================
# GCP CONFIGURATION
# ============================================================
# Authenticates using service account or gcloud CLI
# Project and region from variables
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
