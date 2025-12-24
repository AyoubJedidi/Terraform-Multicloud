# ============================================================
# OUTPUTS.TF
# ============================================================
# PURPOSE: Display deployment results
#
# WHAT IT DOES:
# 1. Shows information after terraform apply completes
# 2. Jenkins/CI reads these values
# 3. User sees URLs, IPs, resource names
#
# HOW TO USE:
#   terraform output app_url
#   terraform output -json > deployment.json
# ============================================================

# ============================================================
# DEPLOYMENT INFO
# ============================================================

output "deployment_type" {
  description = "Type of deployment (webapp or docker-vm)"
  value       = var.deployment_type
}

output "cloud_provider" {
  description = "Cloud provider used (azure, aws, or gcp)"
  value       = var.cloud_provider
}

output "environment" {
  description = "Environment (dev, staging, prod)"
  value       = var.environment
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

# ============================================================
# WEB APP OUTPUTS (if deployment_type = "webapp")
# ============================================================

output "webapp_url" {
  description = "Web App production URL"
  value       = var.deployment_type == "webapp" ? try(module.webapp[0].app_url, "Not deployed") : "N/A"
}

output "webapp_staging_url" {
  description = "Web App staging URL (Blue/Green)"
  value       = var.deployment_type == "webapp" ? try(module.webapp[0].staging_url, "Not deployed") : "N/A"
}

output "webapp_name" {
  description = "Web App resource name"
  value       = var.deployment_type == "webapp" ? try(module.webapp[0].app_name, "Not deployed") : "N/A"
}

# ============================================================
# VM OUTPUTS (if deployment_type = "docker-vm")
# ============================================================

output "vm_ip" {
  description = "VM public IP address"
  value       = var.deployment_type == "docker-vm" ? try(module.docker_vm[0].vm_ip, "Not deployed") : "N/A"
}

output "vm_ssh_command" {
  description = "SSH command to connect to VM"
  value       = var.deployment_type == "docker-vm" ? try(module.docker_vm[0].ssh_command, "Not deployed") : "N/A"
}

output "vm_name" {
  description = "VM resource name"
  value       = var.deployment_type == "docker-vm" ? try(module.docker_vm[0].vm_name, "Not deployed") : "N/A"
}

# ============================================================
# RESOURCE GROUP (Azure only)
# ============================================================

output "resource_group_name" {
  description = "Azure resource group name"
  value       = var.cloud_provider == "azure" ? try(azurerm_resource_group.main[0].name, "Not created") : "N/A"
}
