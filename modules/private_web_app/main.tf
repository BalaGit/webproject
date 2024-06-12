resource "azurerm_linux_web_app" "private_api_app" {
  name                = var.private_api_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id

  site_config {
    always_on = "true"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = "8080"
    COSMOSDB_ENDPOINT                   = var.cosmosdb_account_endpoint
    COSMOSDB_KEY                        = var.cosmosdb_account_key
    REDIS_HOSTNAME                      = var.redis_hostname
    REDIS_PRIMARY_KEY                   = var.redis_primary_key
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "private_api_app_pe" {
  name                = "${var.private_api_app_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_api_subnet_id

  private_service_connection {
    name                           = "appservice-privatelink"
    private_connection_resource_id = azurerm_linux_web_app.private_api_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = "false"
  }
}

resource "azurerm_private_dns_zone" "api_private_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "api_a_record" {
  name                = azurerm_linux_web_app.private_api_app.name
  zone_name           = azurerm_private_dns_zone.api_private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_api_app_pe.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "api_dns_vnet_link" {
  name                  = "${azurerm_private_dns_zone.api_private_dns_zone.name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.api_private_dns_zone.name
  virtual_network_id    = var.vnet_id
}
