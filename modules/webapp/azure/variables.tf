# ============================================================
# AZURE WEB APP MODULE - VARIABLES
# ============================================================

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "docker_image" {
  description = "Docker image (registry/image:tag)"
  type        = string
}

variable "registry_server" {
  description = "Container registry server"
  type        = string
}

variable "registry_username" {
  description = "Registry username"
  type        = string
  sensitive   = true
}

variable "registry_password" {
  description = "Registry password"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "App Service Plan SKU"
  type        = string
  default     = "S3"
}

variable "enable_blue_green" {
  description = "Enable Blue/Green deployment"
  type        = bool
  default     = true
}

variable "enable_auto_swap" {
  description = "Enable auto-swap"
  type        = bool
  default     = true
}
