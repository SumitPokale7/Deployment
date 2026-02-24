resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage_Name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET"]
      allowed_origins    = [var.back_end_cors_trustage]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }
  tags = local.trustage_tags
}
resource "azurerm_storage_container" "storage_container" {
  name                  = var.blob_container
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}
