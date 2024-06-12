provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

module "resource_group" {
  source = "./modules/resource_group"
  web_app_resource_group_name = var.web_app_resource_group_name
  network_resource_group_name = var.network_resource_group_name
  location                    = var.location
}

module "network" {
  source = "./modules/network"
  vnet_name               = var.vnet_name
  vnet_cidr               = var.vnet_cidr
  app_gateway_subnet_cidr = var.app_gateway_subnet_cidr
  api_plink_subnet_cidr   = var.api_plink_subnet_cidr
  private_api_subnet_cidr = var.private_api_subnet_cidr
  database_subnet_cidr    = var.database_subnet_cidr
  network_resource_group_name = module.resource_group.network_resource_group_id
  location                    = var.location
}

module "database" {
  source = "./modules/cosmos_account"
  cosmosdb_account_name     = var.cosmosdb_account_name
  location                  = var.location
  web_app_resource_group_name = module.resource_group.web_app_resource_group_id
  collection_name           = var.collection_name
  database_name             = var.database_name
  database_subnet_id        = module.network.database_subnet_id
  vnet_id                   = module.network.vnet_id
}

module "redis_cache" {
  source = "./modules/redis_cache"
  redis_cache_name          = var.redis_cache_name
  location                  = var.location
  resource_group_name       = module.resource_group.web_app_resource_group_id
  capacity                  = var.redis_capacity
  family                    = var.redis_family
  sku_name                  = var.redis_sku_name
  redis_subnet_id           = module.network.api_plink_subnet_id
  vnet_id                   = module.network.vnet_id
}

module "app_service_plan" {
  source = "./modules/app_service"
  app_service_plan_name = var.app_service_plan_name
  location              = var.location
  resource_group_name   = module.resource_group.web_app_resource_group_id
}

module "private_web_app" {
  source = "./modules/private_web_app"
  private_api_app_name      = var.api_app_name
  resource_group_name       = module.resource_group.web_app_resource_group_id
  location                  = var.location
  app_service_plan_id       = module.app_service_plan.app_service_plan_id
  private_api_subnet_id     = module.network.private_api_subnet_id
  cosmosdb_account_endpoint = module.database.cosmosdb_account_endpoint
  cosmosdb_account_key      = module.database.cosmosdb_account_key
  redis_hostname            = module.redis_cache.redis_hostname
  redis_primary_key         = module.redis_cache.redis_primary_key
  vnet_id                   = module.network.vnet_id
}

module "public_web_app" {
  source = "./modules/public_web_app"
  frontend_app_name               = var.frontend_app_name
  resource_group_name             = module.resource_group.web_app_resource_group_id
  location                        = var.location
  app_service_plan_id             = module.app_service_plan.app_service_plan_id
  private_api_app_private_endpoint_ip = module.private_web_app.private_api_app_private_endpoint_ip
  cosmosdb_account_endpoint       = module.database.cosmosdb_account_endpoint
  cosmosdb_account_key            = module.database.cosmosdb_account_key
  redis_hostname            = module.redis_cache.redis_hostname
  redis_primary_key         = module.redis_cache.redis_primary_key
}

# Public IP for Application Gateway
resource "azurerm_public_ip" "appgwayip" {
  name                = "${var.app_gateway_name}-pip"
  location            = var.location
  resource_group_name = module.resource_group.network_resource_group_id
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"] # Specify the zones for redundancy

  tags = var.tags
}

module "app_gateway" {
  source = "./modules/app_gateway"
  app_gateway_name         = var.app_gateway_name
  location                 = var.location
  resource_group_name      = module.resource_group.network_resource_group_id
  subnet_id                = module.network.app_gateway_subnet_id
  app_gateway_public_ip_cidr = var.app_gateway_public_ip_cidr
  ssl_certificate_path     = var.ssl_certificate_path
  ssl_certificate_password = var.ssl_certificate_password
  backend_fqdn             = module.private_web_app.private_api_app_default_hostname
  tags                     = var.tags
}