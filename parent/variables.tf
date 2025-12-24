# ============================================================
# VARIABLES.TF
# ============================================================
# PURPOSE: Define all input parameters
#
# WHAT IT DOES:
# 1. Lists all configurable values
# 2. Sets types (string, number, bool, list)
# 3. Provides defaults and validation
#
# HOW TO USE:
# - Users provide values in terraform.tfvars
# - Or pass via command: terraform apply -var="project_name=myapp"
# ============================================================

# ============================================================
# GLOBAL VARIABLES
# ============================================================

variable "environment" {
  description = "Environment name: dev, staging, or prod"
  type        = string
  default     = "dev"

  # Ensures only valid values
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod"
  }
}

variable "project_name" {
  description = "Project name (used in resource naming)"
  type        = string

  # Must be provided by user
  validation {
    condition     = length(var.project_name) > 0
    error_message = "project_name cannot be empty"
  }
}

# ============================================================
# DEPLOYMENT CONFIGURATION
# ============================================================

variable "deployment_type" {
  description = "Deployment type: 'webapp' (PaaS) or 'docker-vm' (VM with Docker)"
  type        = string
  default     = "webapp"

  validation {
    condition     = contains(["webapp", "docker-vm"], var.deployment_type)
    error_message = "deployment_type must be 'webapp' or 'docker-vm'"
  }
}

variable "cloud_provider" {
  description = "Cloud provider: azure, aws, or gcp"
  type        = string

  validation {
    condition     = contains(["azure", "aws", "gcp"], var.cloud_provider)
    error_message = "cloud_provider must be azure, aws, or gcp"
  }
}

# ============================================================
# AZURE VARIABLES
# ============================================================

variable "azure_location" {
  description = "Azure region (e.g., francecentral, westeurope)"
  type        = string
  default     = "francecentral"
}

variable "azure_resource_group" {
  description = "Azure resource group name (will be created if doesn't exist)"
  type        = string
}

# ============================================================
# AWS VARIABLES
# ============================================================

variable "aws_region" {
  description = "AWS region (e.g., eu-west-3 = Paris)"
  type        = string
  default     = "eu-west-3"
}

# ============================================================
# GCP VARIABLES
# ============================================================

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region (e.g., europe-west1 = Belgium)"
  type        = string
  default     = "europe-west1"
}

# ============================================================
# CONTAINER CONFIGURATION
# ============================================================

variable "docker_image" {
  description = "Full Docker image path (e.g., myacr.azurecr.io/app:v1)"
  type        = string
}

variable "registry_server" {
  description = "Container registry server (e.g., myacr.azurecr.io)"
  type        = string
}

variable "registry_username" {
  description = "Container registry username"
  type        = string
  sensitive   = true # Hides value in logs
}

variable "registry_password" {
  description = "Container registry password"
  type        = string
  sensitive   = true # Hides value in logs
}
