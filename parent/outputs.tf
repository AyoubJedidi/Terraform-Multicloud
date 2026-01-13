# ============================================================
# OUTPUTS.TF
# ============================================================
# PURPOSE: Display deployment results
# ============================================================

# ============================================================
# DEPLOYMENT INFO
# ============================================================

output "deployment_type" {
  description = "Type of deployment"
  value       = var.deployment_type
}

output "cloud_provider" {
  description = "Cloud provider used"
  value       = var.cloud_provider
}

output "environment" {
  description = "Environment"
  value       = var.environment
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

# ============================================================
# UNIFIED OUTPUTS (Works for any cloud)
# ============================================================

output "deployment_url" {
  description = "Deployment URL (web app)"
  value = (
    var.deployment_type == "webapp" ? (
      var.cloud_provider == "azure" ? try(module.azure_webapp[0].app_url, "N/A") :
      var.cloud_provider == "aws" ? try(module.aws_webapp[0].app_url, "N/A") :
      var.cloud_provider == "gcp" ? try(module.gcp_webapp[0].app_url, "N/A") :
      "N/A"
    ) : "N/A (VM deployment - check vm_ip)"
  )
}

output "staging_url" {
  description = "Staging URL (if Blue/Green enabled)"
  value = (
    var.deployment_type == "webapp" && var.cloud_provider == "azure" ?
    try(module.azure_webapp[0].staging_url, "N/A") : "N/A"
  )
}

output "vm_ip" {
  description = "VM IP address (if docker-vm deployment)"
  value = (
    var.deployment_type == "docker-vm" ? (
      var.cloud_provider == "azure" ? try(module.azure_docker_vm[0].vm_ip, "N/A") :
      var.cloud_provider == "aws" ? try(module.aws_docker_vm[0].vm_ip, "N/A") :
      var.cloud_provider == "gcp" ? try(module.gcp_docker_vm[0].vm_ip, "N/A") :
      "N/A"
    ) : "N/A (webapp deployment - check deployment_url)"
  )
}

# ============================================================
# CLOUD-SPECIFIC OUTPUTS
# ============================================================

# Azure
output "azure_webapp_url" {
  description = "Azure Web App URL"
  value       = var.cloud_provider == "azure" && var.deployment_type == "webapp" ? try(module.azure_webapp[0].app_url, "N/A") : "N/A"
}

output "azure_webapp_name" {
  description = "Azure Web App name"
  value       = var.cloud_provider == "azure" && var.deployment_type == "webapp" ? try(module.azure_webapp[0].app_name, "N/A") : "N/A"
}

output "azure_resource_group" {
  description = "Azure resource group name"
  value       = var.cloud_provider == "azure" ? try(azurerm_resource_group.main[0].name, "N/A") : "N/A"
}

# AWS
output "aws_webapp_url" {
  description = "AWS ECS URL"
  value       = var.cloud_provider == "aws" && var.deployment_type == "webapp" ? try(module.aws_webapp[0].app_url, "N/A") : "N/A"
}

# GCP
output "gcp_webapp_url" {
  description = "GCP Cloud Run URL"
  value       = var.cloud_provider == "gcp" && var.deployment_type == "webapp" ? try(module.gcp_webapp[0].app_url, "N/A") : "N/A"
}
