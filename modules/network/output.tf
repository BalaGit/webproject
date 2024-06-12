output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway_subnet.id
}

output "api_plink_subnet_id" {
  value = azurerm_subnet.api_plink_subnet.id
}

output "private_api_subnet_id" {
  value = azurerm_subnet.private_api_subnet.id
}

output "database_subnet_id" {
  value = azurerm_subnet.database_subnet.id
}
