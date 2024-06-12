output "cosmosdb_account_endpoint" {
  value = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "cosmosdb_account_key" {
  value = azurerm_cosmosdb_account.cosmosdb.primary_key
}


output "cosmosdb_private_endpoint_ip" {
  value = azurerm_private_endpoint.cosmosdb_pe.private_service_connection[0].private_ip_address
}
