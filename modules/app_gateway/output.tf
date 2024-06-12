output "app_gateway_id" {
  value = azurerm_application_gateway.app_gateway.id
}

output "app_gateway_public_ip" {
  value = azurerm_application_gateway.app_gateway.frontend_ip_configuration[0].public_ip_address_id
}
