resource "azurerm_linux_web_app" "frontend_app" {
  name                = var.frontend_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id

  site_config {
    always_on = "true"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = "3000"
    API_BASE_URL                        = "https://${var.private_api_app_private_endpoint_ip}"
    COSMOSDB_ENDPOINT                   = var.cosmosdb_account_endpoint
    COSMOSDB_KEY                        = var.cosmosdb_account_key
    REDIS_HOSTNAME                      = var.redis_hostname
    REDIS_PRIMARY_KEY                   = var.redis_primary_key
  }

  identity {
    type = "SystemAssigned"
  }
}
