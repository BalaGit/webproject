output "private_api_app_default_hostname" {
  value = azurerm_linux_web_app.private_api_app.default_hostname
}

output "private_api_app_private_endpoint_ip" {
  value = azurerm_private_endpoint.private_api_app_pe.private_service_connection[0].private_ip_address
}
