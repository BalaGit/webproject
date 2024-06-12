# modules/resource_group/main.tf
resource "azurerm_resource_group" "myfdev_ms" {
  name     = var.web_app_resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "network" {
  name     = var.network_resource_group_name
  location = var.location
}
