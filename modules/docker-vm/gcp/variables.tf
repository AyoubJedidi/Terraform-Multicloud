variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "gcp_project" {
  description = "GCP project"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "docker_image" {
  description = "Docker image"
  type        = string
  default     = ""
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "e2-small"
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "ubuntu"
}
