variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "docker_image" {
  description = "Docker image"
  type        = string
}

variable "registry_server" {
  description = "Registry server"
  type        = string
}

variable "registry_username" {
  description = "Registry username"
  type        = string
}

variable "registry_password" {
  description = "Registry password"
  type        = string
  sensitive   = true
}
