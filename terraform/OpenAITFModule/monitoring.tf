resource "azurerm_application_insights" "ais" {
  name                = var.ais_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = local.trustage_tags
}