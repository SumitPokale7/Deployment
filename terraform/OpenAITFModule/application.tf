data "azurerm_key_vault" "atlas_front_end_cert" {
  name                = var.front_end_cert_kv_name
  resource_group_name = var.front_end_cert_kv_resource_group_name
}

data "azurerm_key_vault_secret" "atlas_kv_front_end_cert_secret" {
  name         = var.front_end_azurerm_app_service_certificate_name
  key_vault_id = data.azurerm_key_vault.atlas_front_end_cert.id
}

data "azurerm_key_vault_secret" "atlas_kv_front_end_cert_password" {
  name         = var.front_end_azurerm_app_service_certificate_password
  key_vault_id = data.azurerm_key_vault.atlas_front_end_cert.id
}
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  tags = local.trustage_tags
}

resource "azurerm_subnet" "agwaf_subnet" {
  name                 = "agwaf_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.6.0/26"]
}


resource "azurerm_network_security_group" "agwaf_subnet" {
  name                = var.agwaf_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "internet443inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # azure requires this block to present
  security_rule {
    name                       = "AgWafv2TCPRequired"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "DenyAnyAnyInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.trustage_tags

}

resource "azurerm_subnet_network_security_group_association" "agwaf" {
  subnet_id                 = azurerm_subnet.agwaf_subnet.id
  network_security_group_id = azurerm_network_security_group.agwaf_subnet.id
}


resource "azurerm_network_security_group" "private_endpoint" {  

  name                = var.private_endpoint_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [security_rule]
  }

  tags = local.trustage_tags

}

resource "azurerm_subnet_network_security_group_association" "private_endpoint" {
  subnet_id                 = azurerm_subnet.private_endpoint.id
  network_security_group_id = azurerm_network_security_group.private_endpoint.id
}

resource "azurerm_subnet" "private_endpoint" {
  name                 = var.private_endpoint_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]

  #private_endpoint_network_policies_enabled = true
  private_endpoint_network_policies = "Enabled"

}
