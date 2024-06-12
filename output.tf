output "api_app_default_hostname" {
  value = module.private_web_app.private_api_app_default_hostname
}

output "frontend_app_default_hostname" {
  value = module.public_web_app.frontend_app_default_hostname
}

output "resource_group_ids" {
  value = {
    web_app_resource_group_id = module.resource_group.web_app_resource_group_id
    network_resource_group_id = module.resource_group.network_resource_group_id
  }
}

output "network_ids" {
  value = {
    vnet_id              = module.network.vnet_id
    app_gateway_subnet_id = module.network.app_gateway_subnet_id
    api_plink_subnet_id  = module.network.api_plink_subnet_id
    private_api_subnet_id = module.network.private_api_subnet_id
    database_subnet_id   = module.network.database_subnet_id
  }
}

output "app_gateway" {
  value = {
    app_gateway_id   = module.app_gateway.app_gateway_id
    public_ip        = module.app_gateway.app_gateway_public_ip
  }
}

output "cosmosdb" {
  value = {
    endpoint = module.database.cosmosdb_account_endpoint
    key      = module.database.cosmosdb_account_key
  }
}

output "redis_cache" {
value = {
hostname = module.redis_cache.redis_hostname
key = module.redis_cache.redis_primary_key
}
}
