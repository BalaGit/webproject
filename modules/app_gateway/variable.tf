variable "app_gateway_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "app_gateway_public_ip_cidr" {}
variable "backend_fqdn" {}
variable "ssl_certificate_path" {}
variable "ssl_certificate_password" {}
variable "tags" {
  type = map(string)
  default = {}
}
