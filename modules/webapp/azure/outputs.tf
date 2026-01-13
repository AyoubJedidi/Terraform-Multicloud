output "app_url" {
  description = "Web App URL"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "app_name" {
  description = "Web App name"
  value       = azurerm_linux_web_app.main.name
}

output "staging_url" {
  description = "Staging slot URL"
  value       = var.enable_blue_green ? "https://${azurerm_linux_web_app_slot.staging[0].default_hostname}" : null
}
