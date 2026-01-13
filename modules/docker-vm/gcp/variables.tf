variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "docker_image" {
  type = string
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "location" {
  type    = string
  default = null
}

variable "aws_region" {
  type    = string
  default = null
}

variable "gcp_project" {
  type    = string
  default = null
}

variable "gcp_region" {
  type    = string
  default = null
}
