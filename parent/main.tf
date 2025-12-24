# ============================================================
# MAIN.TF
# ============================================================
# PURPOSE: Main deployment orchestrator
#
# WHAT IT DOES:
# 1. Creates shared resources (resource groups)
# 2. Calls child modules (webapp OR docker-vm)
# 3. Routes to correct cloud provider
#
# FLOW:
#   User sets: deployment_type = "webapp", cloud_provider = "azure"
#   → This file creates Azure resource group
#   → Then calls modules/webapp/azure/main.tf
#   → Child module creates App Service
# ============================================================

# ============================================================
# SHARED RESOURCES
# ============================================================

# Azure Resource Group (shared by all Azure resources)
resource "azurerm_resource_group" "main" {
  # Only create if using Azure
  count    = var.cloud_provider == "azure" ? 1 : 0
  
  name     = var.azure_resource_group
  location = var.azure_location
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }
}

# ============================================================
# CHILD MODULE: WEB APP (PaaS)
# ============================================================
# Called when: deployment_type = "webapp"
# Creates: App Service (Azure), ECS (AWS), or Cloud Run (GCP)

module "webapp" {
  # Only create if deployment_type is "webapp"
  count  = var.deployment_type == "webapp" ? 1 : 0
  
  # Path to child module (e.g., modules/webapp/azure/)
  source = "../modules/webapp/${var.cloud_provider}"
  
  # Pass variables to child module
  project_name      = var.project_name
  environment       = var.environment
  docker_image      = var.docker_image
  registry_server   = var.registry_server
  registry_username = var.registry_username
  registry_password = var.registry_password
  
  # Azure-specific (only used if cloud_provider = "azure")
  resource_group_name = var.cloud_provider == "azure" ? azurerm_resource_group.main[0].name : null
  location            = var.azure_location
  
  # AWS-specific (only used if cloud_provider = "aws")
  aws_region = var.aws_region
  
  # GCP-specific (only used if cloud_provider = "gcp")
  gcp_project = var.gcp_project
  gcp_region  = var.gcp_region
}

# ============================================================
# CHILD MODULE: DOCKER VM
# ============================================================
# Called when: deployment_type = "docker-vm"
# Creates: VM with Docker Engine

module "docker_vm" {
  # Only create if deployment_type is "docker-vm"
  count  = var.deployment_type == "docker-vm" ? 1 : 0
  
  # Path to child module (e.g., modules/docker-vm/azure/)
  source = "../modules/docker-vm/${var.cloud_provider}"
  
  # Pass variables to child module
  project_name = var.project_name
  environment  = var.environment
  docker_image = var.docker_image
  
  # Cloud-specific variables
  resource_group_name = var.cloud_provider == "azure" ? azurerm_resource_group.main[0].name : null
  location            = var.azure_location
  aws_region          = var.aws_region
  gcp_project         = var.gcp_project
  gcp_region          = var.gcp_region
}

# ============================================================
# NOTES
# ============================================================
# - Only ONE module runs (webapp OR docker-vm)
# - Module path changes based on cloud_provider
#   Example: cloud_provider="azure" → modules/webapp/azure/
# - count = 1 ? 1 : 0 means "create if true, skip if false"
# - Variables with "null" are ignored by modules that don't need them
