# ============================================================
# OUTPUTS
# ============================================================

# Azure WebApp Outputs
output "azure_webapp_url" {
  description = "Azure Web App URL"
  value       = var.cloud_provider == "azure" && var.deployment_type == "webapp" ? module.azure_webapp[0].webapp_url : null
}

# Azure Docker VM Outputs
output "vm_public_ip" {
  description = "Public IP of the VM"
  value       = var.cloud_provider == "azure" && var.deployment_type == "docker-vm" ? module.azure_docker_vm[0].vm_public_ip : null
}

output "vm_private_key" {
  description = "Private SSH key for VM"
  value       = var.cloud_provider == "azure" && var.deployment_type == "docker-vm" ? module.azure_docker_vm[0].vm_private_key : null
  sensitive   = true
}

output "vm_username" {
  description = "VM username"
  value       = var.cloud_provider == "azure" && var.deployment_type == "docker-vm" ? module.azure_docker_vm[0].vm_username : "azureuser"
}

output "vm_ip" {
  description = "VM IP (alias for Ansible)"
  value       = var.cloud_provider == "azure" && var.deployment_type == "docker-vm" ? module.azure_docker_vm[0].vm_public_ip : null
}

output "vm_user" {
  description = "VM User (alias for Ansible)"
  value       = var.cloud_provider == "azure" && var.deployment_type == "docker-vm" ? module.azure_docker_vm[0].vm_username : "azureuser"
}

# AWS Outputs (when implemented)
output "aws_webapp_url" {
  description = "AWS App URL"
  value       = var.cloud_provider == "aws" && var.deployment_type == "webapp" ? "TBD" : null
}

# GCP Outputs (when implemented)
output "gcp_webapp_url" {
  description = "GCP App URL"
  value       = var.cloud_provider == "gcp" && var.deployment_type == "webapp" ? "TBD" : null
}
