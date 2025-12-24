# ============================================================
<<<<<<< HEAD
# MAIN.TF (FIXED)
# ============================================================
# PURPOSE: Main deployment orchestrator
#
# FIX: Terraform doesn't allow variables in module source
# SOLUTION: Use separate module blocks for each cloud
=======
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
>>>>>>> a3d9a361c8e81291de6a912aacb74c26dec9460d
# ============================================================

# ============================================================
# SHARED RESOURCES
# ============================================================

<<<<<<< HEAD
# Azure Resource Group
resource "azurerm_resource_group" "main" {
  count    = var.cloud_provider == "azure" ? 1 : 0
=======
# Azure Resource Group (shared by all Azure resources)
resource "azurerm_resource_group" "main" {
  # Only create if using Azure
  count    = var.cloud_provider == "azure" ? 1 : 0
  
>>>>>>> a3d9a361c8e81291de6a912aacb74c26dec9460d
  name     = var.azure_resource_group
  location = var.azure_location
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
<<<<<<< HEAD
=======
    CreatedAt   = timestamp()
>>>>>>> a3d9a361c8e81291de6a912aacb74c26dec9460d
  }
}

# ============================================================
<<<<<<< HEAD
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
  
=======
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
>>>>>>> a3d9a361c8e81291de6a912aacb74c26dec9460d
  docker_image      = var.docker_image
  registry_server   = var.registry_server
  registry_username = var.registry_username
  registry_password = var.registry_password
<<<<<<< HEAD
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
=======
  
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
>>>>>>> a3d9a361c8e81291de6a912aacb74c26dec9460d
}

# ============================================================
# NOTES
# ============================================================
<<<<<<< HEAD
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
=======
# - Only ONE module runs (webapp OR docker-vm)
# - Module path changes based on cloud_provider
#   Example: cloud_provider="azure" → modules/webapp/azure/
# - count = 1 ? 1 : 0 means "create if true, skip if false"
# - Variables with "null" are ignored by modules that don't need them
>>>>>>> a3d9a361c8e81291de6a912aacb74c26dec9460d
