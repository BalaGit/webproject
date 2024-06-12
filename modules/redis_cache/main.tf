resource "azurerm_redis_cache" "redis" {
  name                = var.redis_cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name

  enable_non_ssl_port = false

  redis_configuration {
    maxmemory_policy = "allkeys-lru" # Eviction policy
    maxmemory_reserved  = "30"
    maxfragmentationmemory_reserved = "30"
  }
}

resource "azurerm_private_endpoint" "redis_pe" {
  name                = "${var.redis_cache_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.redis_subnet_id

  private_service_connection {
    name                           = "redis-privatelink"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = "false"
  }
}

resource "azurerm_private_dns_zone" "redis_private_dns_zone" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "redis_a_record" {
  name                = azurerm_redis_cache.redis.name
  zone_name           = azurerm_private_dns_zone.redis_private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.redis_pe.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis_dns_vnet_link" {
  name                  = "${azurerm_private_dns_zone.redis_private_dns_zone.name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis_private_dns_zone.name
  virtual_network_id    = var.vnet_id
}
