resource "azurerm_cognitive_account" "form_recognizer" {
  name                          = var.form_recognizer_name
  location                      = var.form_recognizer_location
  resource_group_name           = var.resource_group_name
  kind                          = "FormRecognizer"
  public_network_access_enabled = false
  sku_name                      = "S0"
  custom_subdomain_name         = var.form_recognizer_subdomain_name
  tags                          = local.trustage_tags
}


resource "azurerm_private_dns_zone" "form_recognizer" {
  name                = var.document_intelligenceopenai_private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = local.trustage_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "form_recognizer" {
  name                  = var.azurerm_private_dns_zone_virtual_network_link_search
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.form_recognizer.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.trustage_tags
}

resource "azurerm_private_endpoint" "form_recognizer" {
  name                = var.document_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = var.document_reader_service_connection_name
    private_connection_resource_id = azurerm_cognitive_account.form_recognizer.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }
  tags = local.trustage_tags

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.form_recognizer.id]
  }
}

# create translation cognitive account
resource "azurerm_cognitive_account" "translator" {

  name                          = var.translator_name
  location                      = var.translator_location
  resource_group_name           = var.resource_group_name
  kind                          = "TextTranslation"
  public_network_access_enabled = false
  sku_name                      = "S1"
  custom_subdomain_name         = var.translator_subdomain_name
  identity {
    type = "SystemAssigned"
  }

  tags = local.trustage_tags
}

resource "azurerm_private_endpoint" "translator" {

  name                = var.translator_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = var.translator_private_service_connection_name
    private_connection_resource_id = azurerm_cognitive_account.translator.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }
  tags = local.trustage_tags
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.form_recognizer.id]
  }
}

resource "azurerm_private_dns_zone" "openai" {
  name                = var.openai_private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = local.trustage_tags
}

# Dynamic OpenAI Cognitive Accounts with Models
resource "azurerm_cognitive_account" "openai_accounts" {
  for_each = var.openai_accounts

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = var.resource_group_name
  kind                          = "OpenAI"
  public_network_access_enabled = false
  sku_name                      = each.value.sku_name
  custom_subdomain_name         = each.value.subdomain_name

  tags = local.trustage_tags
}

# Private Endpoints for OpenAI Accounts
resource "azurerm_private_endpoint" "openai_accounts" {
  for_each = var.openai_accounts

  name                = each.value.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = azurerm_cognitive_account.openai_accounts[each.key].id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.openai.id]
  }

  tags = local.trustage_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "openai" {
  name                  = var.azurerm_private_dns_zone_virtual_network_link_openai
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.openai.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.trustage_tags
}

# Dynamic Model Deployments
resource "azurerm_cognitive_deployment" "openai_models" {
  for_each = local.flattened_models

  name                 = each.value.deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai_accounts[each.value.account_key].id

  model {
    format = "OpenAI"
    name   = each.value.model_name
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.capacity
  }

  lifecycle {
    ignore_changes = [model[0].version]
  }
}

