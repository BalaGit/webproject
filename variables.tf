variable "location" {}
variable "web_app_resource_group_name" {}
variable "network_resource_group_name" {}
variable "app_service_plan_name" {}
variable "api_app_name" {}
variable "frontend_app_name" {}
variable "vnet_name" {}
variable "vnet_cidr" {}
variable "app_gateway_subnet_cidr" {}
variable "api_plink_subnet_cidr" {}
variable "private_api_subnet_cidr" {}
variable "database_subnet_cidr" {}
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {
  sensitive = true
}
variable "tenant_id" {}
variable "app_gateway_name" {}
variable "app_gateway_public_ip_cidr" {}
variable "app_gateway_public_ip_id" {}
variable "ssl_certificate_path" {}
variable "ssl_certificate_password" {
  sensitive = true
}
variable "cosmosdb_account_name" {}
variable "collection_name" {}
variable "database_name" {}
variable "redis_cache_name" {}
variable "redis_capacity" {}
variable "redis_family" {}
variable "redis_sku_name" {}
variable "tags" {
  type = map(string)
  default = {}
}
