# modules/resource_group/outputs.tf
output "web_app_resource_group_id" {
  value = azurerm_resource_group.myfdev_ms.id
}

output "network_resource_group_id" {
  value = azurerm_resource_group.network.id
}
