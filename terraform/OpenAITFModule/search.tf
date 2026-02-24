resource "azurerm_search_service" "search_sevice" {
  name                          = var.search_sevice_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = "basic"
  public_network_access_enabled = false
  semantic_search_sku           = "free"

  local_authentication_enabled = true
  authentication_failure_mode  = "http403"
  tags                         = local.trustage_tags

}

resource "azurerm_private_dns_zone" "search" {
  name                = var.search_private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = local.trustage_tags
}

resource "azurerm_private_endpoint" "search" {
  name                = var.search_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = var.search_private_service_connection_name
    private_connection_resource_id = azurerm_search_service.search_sevice.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }
  tags = local.trustage_tags

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.search.id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "search" {
  name                  = var.azurerm_private_dns_zone_virtual_network_link_search
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.search.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.trustage_tags
}
