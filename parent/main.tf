# ============================================================
# MAIN.TF (FIXED)
# ============================================================
# PURPOSE: Main deployment orchestrator
#
# FIX: Terraform doesn't allow variables in module source
# SOLUTION: Use separate module blocks for each cloud
# ============================================================

# ============================================================
# SHARED RESOURCES
# ============================================================

# Azure Resource Group
resource "azurerm_resource_group" "main" {
  count    = var.cloud_provider == "azure" ? 1 : 0
  name     = var.azure_resource_group
  location = var.azure_location
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# AZURE WEB APP MODULE
# ============================================================
# Runs when: cloud_provider="azure" AND deployment_type="webapp"

module "azure_webapp" {
  count  = var.cloud_provider == "azure" && var.deployment_type == "webapp" ? 1 : 0
  source = "../modules/webapp/azure"
  
  project_name        = var.project_name
  environment         = var.environment
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main[0].name
  
  docker_image      = var.docker_image
  registry_server   = var.registry_server
  registry_username = var.registry_username
  registry_password = var.registry_password
}

# ============================================================
# AWS WEB APP MODULE
# ============================================================
# Runs when: cloud_provider="aws" AND deployment_type="webapp"

module "aws_webapp" {
  count  = var.cloud_provider == "aws" && var.deployment_type == "webapp" ? 1 : 0
  source = "../modules/webapp/aws"
  
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  
  docker_image      = var.docker_image
  registry_server   = var.registry_server
  registry_username = var.registry_username
  registry_password = var.registry_password
}

# ============================================================
# GCP WEB APP MODULE
# ============================================================
# Runs when: cloud_provider="gcp" AND deployment_type="webapp"

module "gcp_webapp" {
  count  = var.cloud_provider == "gcp" && var.deployment_type == "webapp" ? 1 : 0
  source = "../modules/webapp/gcp"
  
  project_name = var.project_name
  environment  = var.environment
  gcp_project  = var.gcp_project
  gcp_region   = var.gcp_region
  
  docker_image      = var.docker_image
  registry_server   = var.registry_server
  registry_username = var.registry_username
  registry_password = var.registry_password
}

# ============================================================
# AZURE DOCKER VM MODULE
# ============================================================
# Runs when: cloud_provider="azure" AND deployment_type="docker-vm"

module "azure_docker_vm" {
  count  = var.cloud_provider == "azure" && var.deployment_type == "docker-vm" ? 1 : 0
  source = "../modules/docker-vm/azure"
  
  project_name        = var.project_name
  environment         = var.environment
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main[0].name
  
  docker_image = var.docker_image
}

# ============================================================
# AWS DOCKER VM MODULE
# ============================================================
# Runs when: cloud_provider="aws" AND deployment_type="docker-vm"

module "aws_docker_vm" {
  count  = var.cloud_provider == "aws" && var.deployment_type == "docker-vm" ? 1 : 0
  source = "../modules/docker-vm/aws"
  
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  
  docker_image = var.docker_image
}

# ============================================================
# GCP DOCKER VM MODULE
# ============================================================
# Runs when: cloud_provider="gcp" AND deployment_type="docker-vm"

module "gcp_docker_vm" {
  count  = var.cloud_provider == "gcp" && var.deployment_type == "docker-vm" ? 1 : 0
  source = "../modules/docker-vm/gcp"
  
  project_name = var.project_name
  environment  = var.environment
  gcp_project  = var.gcp_project
  gcp_region   = var.gcp_region
  
  docker_image = var.docker_image
}

# ============================================================
# NOTES
# ============================================================
# How it works:
#
# Example 1: cloud_provider="azure", deployment_type="webapp"
#   → module.azure_webapp[0] runs (count=1)
#   → All other modules skip (count=0)
#
# Example 2: cloud_provider="aws", deployment_type="docker-vm"
#   → module.aws_docker_vm[0] runs (count=1)
#   → All other modules skip (count=0)
#
# Only ONE module runs at a time based on your configuration!
# ============================================================
