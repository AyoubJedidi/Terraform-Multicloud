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
  default     = "us-east-1"
}

variable "docker_image" {
  description = "Docker image"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.small"
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "ubuntu"
}
