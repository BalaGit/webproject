resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmosdb_account_name
  location            = var.location
  resource_group_name = var.web_app_resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"
  
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_private_endpoint" "cosmosdb_pe" {
  name                = "${var.cosmosdb_account_name}-pe"
  location            = var.location
  resource_group_name = var.web_app_resource_group_name
  subnet_id           = var.database_subnet_id

  private_service_connection {
    name                           = "cosmosdb-privatelink"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    subresource_names              = ["sql"]
    is_manual_connection           = "false"
  }
}

resource "azurerm_private_dns_zone" "cosmosdb_private_dns_zone" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.web_app_resource_group_name
}

resource "azurerm_private_dns_a_record" "cosmosdb_a_record" {
  name                = azurerm_cosmosdb_account.cosmosdb.name
  zone_name           = azurerm_private_dns_zone.cosmosdb_private_dns_zone.name
  resource_group_name = var.web_app_resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.cosmosdb_pe.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb_dns_vnet_link" {
  name                  = "${azurerm_private_dns_zone.cosmosdb_private_dns_zone.name}-link"
  resource_group_name   = var.web_app_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb_private_dns_zone.name
  virtual_network_id    = var.vnet_id
}
