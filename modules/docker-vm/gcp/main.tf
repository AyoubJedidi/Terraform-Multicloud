# ============================================================
# GCP DOCKER VM MODULE
# ============================================================

# SSH Key Generation
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "${var.project_name}-${var.environment}-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_name}-${var.environment}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
}

# Firewall Rules
resource "google_compute_firewall" "ssh" {
  name    = "${var.project_name}-${var.environment}-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.project_name}-vm"]
}

resource "google_compute_firewall" "http" {
  name    = "${var.project_name}-${var.environment}-allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.project_name}-vm"]
}

# Cloud-init
data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    admin_username = var.admin_username
    ssh_public_key = tls_private_key.ssh.public_key_openssh
  }
}

# Compute Instance
resource "google_compute_instance" "vm" {
  name         = "${var.project_name}-${var.environment}-vm"
  machine_type = var.machine_type
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    user-data = data.template_file.cloud_init.rendered
    ssh-keys  = "${var.admin_username}:${tls_private_key.ssh.public_key_openssh}"
  }

  tags = ["${var.project_name}-vm"]

  labels = {
    environment = var.environment
    project     = var.project_name
  }
}
