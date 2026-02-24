# ACR for container app
resource "azurerm_container_registry" "acr" {
  count               = contains(["dev", "prod"], var.environment) ? 1 : 0
  name                = local.acrname
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  admin_enabled       = false
  tags                = local.trustage_tags
}

# container App subnet
resource "azurerm_subnet" "container_app_subnet" {
  name                              = var.aca_subnet_name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = ["10.0.8.0/23"]
  private_endpoint_network_policies = "Disabled"
  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}


resource "azurerm_log_analytics_workspace" "container_app_log_analytics_workspace" {
  name                = var.aca_log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.trustage_tags
}
resource "azurerm_container_app_environment" "private_environment" {
  depends_on                         = [azurerm_subnet.container_app_subnet, azurerm_log_analytics_workspace.container_app_log_analytics_workspace]
  name                               = var.aca_env_name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  infrastructure_subnet_id           = azurerm_subnet.container_app_subnet.id
  internal_load_balancer_enabled     = true
  infrastructure_resource_group_name = var.aca_infrastructure_resource_group_name
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.container_app_log_analytics_workspace.id
  workload_profile {
    maximum_count         = 10
    minimum_count         = 1
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [
      workload_profile
    ]
  }

  tags = local.trustage_tags
}
resource "azurerm_private_endpoint" "aca_env_pe" {
  depends_on          = [azurerm_container_app_environment.private_environment, azurerm_private_dns_zone.aca]
  name                = var.aca_env_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = var.aca_private_endpoint_connection_name
    private_connection_resource_id = azurerm_container_app_environment.private_environment.id
    subresource_names              = ["managedEnvironments"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.aca.id]
  }
  tags = local.trustage_tags
}
resource "azurerm_private_dns_zone" "aca" {
  name                = "privatelink.centralus.azurecontainerapps.io"
  resource_group_name = var.resource_group_name
  tags                = local.trustage_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aca" {
  depends_on            = [azurerm_private_dns_zone.aca]
  name                  = var.aca_private_dns_zone_virtual_network_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aca.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.trustage_tags
}


resource "azurerm_container_app" "container_apps" {
  depends_on                   = [azurerm_container_app_environment.private_environment, azurerm_private_endpoint.aca_env_pe]
  for_each                     = var.container_apps
  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.private_environment.id
  resource_group_name          = var.resource_group_name
  tags                         = local.trustage_tags
  revision_mode                = each.value.revision_mode
  workload_profile_name        = "Consumption"
  identity {
    type = "SystemAssigned"
  }
  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = each.value.target_port
    transport                  = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    revision_suffix = null
    container {
      name   = each.value.name
      image  = each.value.image
      cpu    = each.value.cpu
      memory = each.value.memory
      liveness_probe {
        failure_count_threshold = 2
        port                    = each.value.liveness_probe_port
        path                    = each.value.liveness_probe_path
        transport               = each.value.liveness_probe_transport
      }
    }
    http_scale_rule {
      name                = "http"
      concurrent_requests = 100
    }
    min_replicas = each.value.min_replicas
    max_replicas = each.value.max_replicas

  }
  max_inactive_revisions = each.value.max_inactive_revisions
  lifecycle {
    ignore_changes = [

      template[0].container[0].readiness_probe,
      template[0].container[0].startup_probe,
      template[0].container[0].image,
      template[0].container[0].env,
      registry
    ]
  }
}
