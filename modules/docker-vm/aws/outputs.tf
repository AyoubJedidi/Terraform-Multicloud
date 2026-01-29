output "vm_public_ip" {
  description = "Public IP of the VM"
  value       = aws_instance.vm.public_ip
}

output "vm_private_key" {
  description = "Private SSH key"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "vm_public_key" {
  description = "Public SSH key"
  value       = tls_private_key.ssh.public_key_openssh
}

output "vm_username" {
  description = "VM username"
  value       = var.admin_username
}

output "vm_id" {
  description = "Instance ID"
  value       = aws_instance.vm.id
}

output "vm_name" {
  description = "Instance name"
  value       = aws_instance.vm.tags["Name"]
}
