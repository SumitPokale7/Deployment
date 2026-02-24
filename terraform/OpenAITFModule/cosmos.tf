resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                               = var.cosmosdb_account_name
  resource_group_name                = var.resource_group_name
  location                           = var.location
  offer_type                         = "Standard"
  kind                               = "GlobalDocumentDB"
  public_network_access_enabled      = false
  is_virtual_network_filter_enabled  = true
  multiple_write_locations_enabled   = true
  access_key_metadata_writes_enabled = false

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = local.trustage_tags
}

resource "azurerm_cosmosdb_sql_database" "nosql" {
  name                = var.cosmosdb_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  # throughput          = var.throughput
}


resource "azurerm_private_endpoint" "cosmosdb_endpoint" {
  name                = var.cosmosdb_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = var.cosmos_private_service_connection_name
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb_account.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
  tags = local.trustage_tags

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_dns.id]
  }
}

data "azurerm_cosmosdb_sql_role_definition" "data_contributor" {
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  role_definition_id  = "00000000-0000-0000-0000-000000000002" # UUID
}


resource "azurerm_private_dns_zone" "cosmos_dns" {
  name                = var.cosmos_openai_private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = local.trustage_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_dns_link" {
  name                  = var.azurerm_private_dns_zone_virtual_network_link_cosmos
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.trustage_tags
}
