# ============================================================
# AZURE WEB APP MODULE
# ============================================================
# Creates: App Service Plan, Web App, Staging Slot (Blue/Green)
# ============================================================

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Web App (Production)
resource "azurerm_linux_web_app" "main" {
  name                = "${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  
  site_config {
    always_on = true
    
    application_stack {
      docker_image_name        = var.docker_image
      docker_registry_url      = "https://${var.registry_server}"
      docker_registry_username = var.registry_username
      docker_registry_password = var.registry_password
    }
  }
  
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.registry_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = var.registry_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.registry_password
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Staging Slot (Blue/Green)
resource "azurerm_linux_web_app_slot" "staging" {
  count          = var.enable_blue_green ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.main.id
  
  site_config {
    always_on = true
    
    application_stack {
      docker_image_name        = var.docker_image
      docker_registry_url      = "https://${var.registry_server}"
      docker_registry_username = var.registry_username
      docker_registry_password = var.registry_password
    }
    
    auto_swap_slot_name = var.enable_auto_swap ? "production" : null
  }
  
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.registry_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = var.registry_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.registry_password
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    Slot        = "staging"
  }
}
