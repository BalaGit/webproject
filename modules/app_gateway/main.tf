resource "azurerm_public_ip" "appgwayip" {
  name                = "${var.app_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = var.tags
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "WAF_Medium"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "frontendPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = azurerm_public_ip.appgwayip.id
  }

  ssl_certificate {
    name     = "appGatewaySslCert"
    data     = base64encode(filebase64(var.ssl_certificate_path))
    password = var.ssl_certificate_password
  }

  backend_address_pool {
    name  = "backendAddressPool"
    fqdns = [var.backend_fqdn]  # Use fqdns instead of fqdn
  }

  backend_http_settings {
    name                  = "httpsBackendSetting"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 20

    authentication_certificate {
      name = "appGatewaySslCert"
    }
  }

  http_listener {
    name                           = "httpsListener"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "frontendPort"
    protocol                       = "Https"
    ssl_certificate_name           = "appGatewaySslCert"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "httpsListener"
    backend_address_pool_name  = "backendAddressPool"
    backend_http_settings_name = "httpsBackendSetting"
  }

  tags = var.tags
}
