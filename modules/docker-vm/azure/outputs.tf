output "vm_public_ip" {
  description = "Public IP of the VM"
  value       = azurerm_public_ip.vm.ip_address
}

output "vm_private_key" {
  description = "Private SSH key for VM access"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "vm_public_key" {
  description = "Public SSH key"
  value       = tls_private_key.ssh.public_key_openssh
}

output "vm_username" {
  description = "VM admin username"
  value       = var.admin_username
}

output "vm_id" {
  description = "VM resource ID"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "VM name"
  value       = azurerm_linux_virtual_machine.vm.name
}
