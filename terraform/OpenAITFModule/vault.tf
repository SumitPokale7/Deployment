resource "azurerm_key_vault" "key_vault" {
  enable_rbac_authorization = true
  location                  = var.location
  name                      = var.key_vault_name
  resource_group_name       = var.resource_group_name
  sku_name                  = "standard"
  tenant_id                 = "a00452fd-8469-409e-91a8-bb7a008e2da0"
  tags                      = local.trustage_tags
}

resource "azurerm_key_vault_secret" "cosmos_connection_string" {
  name         = "cosmosdb-connection-string"
  value        = azurerm_cosmosdb_account.cosmosdb_account.primary_key
  key_vault_id = azurerm_key_vault.key_vault.id
}
