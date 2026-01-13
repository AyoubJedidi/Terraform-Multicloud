variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "docker_image" {
  type = string
}

variable "registry_server" {
  type = string
}

variable "registry_username" {
  type      = string
  sensitive = true
}

variable "registry_password" {
  type      = string
  sensitive = true
}

variable "gcp_project" {
  type    = string
  default = null
}

variable "gcp_region" {
  type    = string
  default = null
}
