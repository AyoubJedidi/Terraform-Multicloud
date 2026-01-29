# ============================================================
# AWS DOCKER VM MODULE
# ============================================================

# SSH Key Generation
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# AWS Key Pair
resource "aws_key_pair" "vm" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = tls_private_key.ssh.public_key_openssh

  tags = {
    Name        = "${var.project_name}-${var.environment}-key"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Security Group
resource "aws_security_group" "vm" {
  name        = "${var.project_name}-${var.environment}-vm-sg"
  description = "Security group for Docker VM"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-vm-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.project_name}-${var.environment}-subnet"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rt"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Get Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Cloud-init
data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    admin_username = var.admin_username
    ssh_public_key = tls_private_key.ssh.public_key_openssh
  }
}

# EC2 Instance
resource "aws_instance" "vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.vm.key_name
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.vm.id]
  user_data              = base64encode(data.template_file.cloud_init.rendered)

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-vm"
    Environment = var.environment
    Project     = var.project_name
  }
}
