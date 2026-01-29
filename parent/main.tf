# ============================================================
# MAIN.TF - Multi-Cloud Orchestrator
# ============================================================

# ============================================================
# AZURE RESOURCES
# ============================================================

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
# AZURE MODULES
# ============================================================

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
# AWS MODULES
# ============================================================

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

module "aws_docker_vm" {
  count  = var.cloud_provider == "aws" && var.deployment_type == "docker-vm" ? 1 : 0
  source = "../modules/docker-vm/aws"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  docker_image = var.docker_image
}

# ============================================================
# GCP MODULES
# ============================================================

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

module "gcp_docker_vm" {
  count  = var.cloud_provider == "gcp" && var.deployment_type == "docker-vm" ? 1 : 0
  source = "../modules/docker-vm/gcp"

  project_name = var.project_name
  environment  = var.environment
  gcp_project  = var.gcp_project
  gcp_region   = var.gcp_region

  docker_image = var.docker_image
}
