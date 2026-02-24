variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Location of resource deployed."
}

variable "frontend_nsg_name" {
  description = "NSG name for the front end webapp"
  type        = string
}

variable "backend_nsg_name" {
  description = "NSG name for the back end webapp"
  type        = string
}

variable "vnet_name" {
  description = "Name of the vnet"
  type        = string
}

variable "search_sevice_name" {
  description = "Name of the search service resource"
  type        = string
}

variable "cosmosdb_account_name" {
  description = "Name of the cosmos db account"
  type        = string
}

variable "cosmosdb_name" {
  description = "Name of the cosmosdb inside of the cosmos db account"
  type        = string
}


variable "back_end_cors_trustage" {
  description = "Back end cors value"
  type        = string
}

variable "form_recognizer_name" {
  description = "Name of the form recognizer resource"
  type        = string
}

variable "key_vault_name" {
  description = "Name for the key vault"
  type        = string
}

variable "subscription_id" {
  description = "The subscription id that the resources will be deployed in"
  type        = string
}

variable "ais_name" {
  description = "Name for the application insights resource"
  type        = string
}

variable "cosmosdb_endpoint_name" {
  description = "Name for the cosmosdb private endpoint"
  type        = string
}

variable "cosmos_private_service_connection_name" {
  description = "cosmosDB prive service connection name"
  type        = string
}

variable "private_endpoint_subnet_name" {
  description = "cosmosDB private endpoint subnet name"
  type        = string
}

variable "managed_identity_name" {
  description = "Name for the user assigned managed identity"
  type        = string
}

variable "openai_private_dns_zone_name" {
  description = "Private DNS zone for the OpenAI instance"
  type        = string
}

variable "private_endpoint_nsg_name" {
  description = "Name for the Prive Endpoint NSG"
  type        = string
}

variable "cosmos_openai_private_dns_zone_name" {
  description = "Name for the cosmosDB private DNS Zone"
  type        = string
}

variable "search_private_endpoint_name" {
  description = "Name of the Search private endpoint"
  type        = string
}

variable "search_private_service_connection_name" {
  description = "Name for the search private service connection"
  type        = string
}

variable "search_private_dns_zone_name" {
  description = "Name for the search private DNS zone"
  type        = string
}

variable "azurerm_private_dns_zone_virtual_network_link_search" {
  description = "Name for the search dns zone virtual network link"
  type        = string
}

variable "form_recognizer_subdomain_name" {
  description = "Domain name for the form recognizer"
  type        = string
}

variable "document_intelligenceopenai_private_dns_zone_name" {
  description = "DNS zone name for form recognizer"
  type        = string
}

variable "azurerm_private_fr_dns_zone_virtual_network_link" {
  description = "Name for the form recognizer dns zone virtual link"
  type        = string
}

variable "document_reader_service_connection_name" {
  description = "Name for the form recognizer service connection name"
  type        = string
}

variable "document_private_endpoint_name" {
  description = "Name for the form reader private endpoint"
  type        = string
}


variable "secondary_db_location" {
  description = "Secondary location for cosmos db"
  type        = string
}

variable "openai_subdomain_name" {
  description = "Domain name for the OpenAI instance"
  type        = string
}

variable "form_recognizer_location" {
  description = "Domain name for the OpenAI instance"
  type        = string
}

variable "azurerm_private_dns_zone_virtual_network_link_cosmos" {
  description = "Domain name for the OpenAI instance"
  type        = string
}

variable "azurerm_private_dns_zone_virtual_network_link_openai" {
  description = "Domain name for the OpenAI instance"
  type        = string
}

variable "front_end_cert_id" {
  description = "ID in the Key Vault for the front end certificate"
  type        = string
}

variable "front_end_azurerm_app_service_certificate_name" {
  description = "Name in the Key Vault for the front end certificate"
  type        = string
}

variable "front_end_host_name" {
  description = "Front end DNS Host Name"
  type        = string
}

variable "front_end_cert_kv_name" {
  description = "Front end cert kv name"
  type        = string
}

variable "front_end_cert_kv_resource_group_name" {
  description = "Front end cert kv name"
  type        = string
}

variable "front_end_azurerm_app_service_certificate_password" {
  description = "Password for the front Front end cert in the Azure key vault"
  type        = string
}

variable "embedding_quota" {
  description = "Quota for the form recognizer model - lower in nonprod because we have less quota in nonprod"
  type        = string
}

variable "cmdbAssetTag" {
  description = "tag value for cmdbAssetTag"
  type        = string
}

variable "cmdbFriendlyName" {
  description = "tag value for cmdbFriendlyName"
  type        = string
}

variable "cmdbOwnedBy" {
  description = "tag value for cmdbOwnedBy"
  type        = string
}

variable "cmdbOwnedByEmail" {
  description = "tag value for cmdbOwnedByEmail"
  type        = string
}

variable "cmdbPortfolio" {
  description = "tag value for cmdbPortfolio"
  type        = string
}

variable "agwaf_azurerm_public_ip_name" {
  description = "Name for the public ip associated with the agwaf"
  type        = string
}
variable "agwaf_name" {
  description = "Name of the agwaf"
  type        = string
}

variable "agwaf_nsg_name" {
  description = "Name of the agwaf nsg"
  type        = string
}

variable "front_end_endpoint_name" {
  description = "Name of the front end private endpoint"
  type        = string
}

variable "app_services_private_dns_zone_name" {
  description = "Name of the front end private dns zone"
  type        = string
}

variable "azurerm_private_dns_zone_virtual_network_link_app_services" {
  description = "Name of the front end dns virtual network link"
  type        = string
}

variable "back_end_endpoint_name" {
  description = "Name of the back end private endpoint"
  type        = string
}

variable "black_listed_countries" {
  description = "Black Listed Countries"
  type        = list(string)
}

variable "backend_address_pool_frontend" {
  description = "FQDN for the frontend application for the frontend agwaf pool"
  type        = string
}
variable "backend_address_pool_frontend_inv" {
  description = "FQDN for the frontend application for the frontend agwaf pool"
  type        = string
}

variable "backend_address_pool_backend" {
  description = "FQDN for the backend application for the backend agwaf pool"
  type        = string
}

variable "backend_address_pool_backend_inv" {
  description = "FQDN for the backend application for the backend agwaf pool"
  type        = string
}
variable "backend_address_pool_backend_research" {
  description = "FQDN for the backend application for the backend agwaf pool"
  type        = string
}
variable "backend_address_pool_frontend_research" {
  description = "FQDN for the backend application for the backend agwaf pool"
  type        = string

}


variable "storage_Name" {
  description = "Name of the Storage Account"
  type        = string
}

variable "investment_storage_Name" {
  description = "Name of the Investment Storage Account"
  type        = string
}


variable "blob_container" {
  description = "Name of the Storage Account"
  type        = string
}

variable "environment" {
  type = string
}

variable "aca_subnet_name" {
  description = "Name of the subnet for the container app"
  type        = string
}

variable "aca_log_analytics_workspace_name" {
  description = "Name of the log analytics workspace for the container app"
  type        = string

}
variable "aca_infrastructure_resource_group_name" {
  description = "Name of the resource group for the container app infrastructure"
  type        = string

}

variable "aca_env_private_endpoint_name" {
  description = "Name of the private endpoint for the container app environment"
  type        = string

}

variable "aca_private_endpoint_connection_name" {
  description = "Name of the private endpoint connection for the container app environment"
  type        = string

}

variable "aca_env_name" {
  description = "Name of the container app environment"
  type        = string

}

variable "aca_private_dns_zone_virtual_network_link_name" {
  description = "Name of the private DNS zone virtual network link for the container app"
  type        = string

}


variable "translator_name" {
  description = "Name of the translator resource"
  type        = string

}

variable "translator_location" {
  description = "Location of the translator resource"
  type        = string

}

variable "translator_subdomain_name" {
  description = "Subdomain name for the translator resource"
  type        = string

}

variable "translator_private_endpoint_name" {
  description = "Name of the private endpoint for the translator resource"
  type        = string

}

variable "translator_private_service_connection_name" {
  description = "Name of the private service connection for the translator resource"
  type        = string

}

variable "container_apps" {
  description = "Map of container app configs, including RBAC role assignments and Application Gateway integration."
  type = map(object({
    name                     = string
    revision_mode            = string
    image                    = string
    cpu                      = number
    memory                   = string
    min_replicas             = number
    max_replicas             = number
    liveness_probe_port      = number
    liveness_probe_path      = string
    liveness_probe_transport = string
    target_port              = number
    max_inactive_revisions   = number
    # Application Gateway specific attributes
    agw_enabled                   = optional(bool, false)
    agw_probe_interval            = optional(number, 30)
    agw_probe_timeout             = optional(number, 30)
    agw_probe_unhealthy_threshold = optional(number, 3)
    agw_request_timeout           = optional(number, 90)
    agw_path_patterns             = optional(list(string), ["/"])
    # URL Rewrite Configuration (optional)
    agw_rewrite_enabled  = optional(bool, false)
    agw_rewrite_pattern  = optional(string, "")
    agw_rewrite_path     = optional(string, "/{var_uri_path_1}")
    agw_rewrite_sequence = optional(number, 50)
  }))
}

variable "openai_accounts" {
  description = "Map of OpenAI cognitive accounts with their models"
  type = map(object({
    name                            = string
    location                        = string
    sku_name                        = string
    subdomain_name                  = string
    private_endpoint_name           = string
    private_service_connection_name = string
    models = map(object({
      deployment_name = string
      model_name      = string
      sku_name        = string
      capacity        = number
    }))
  }))
}

variable "apim_ip" {
  description = "IP address of the APIM instance to allow in WAF"
  type        = string
}
variable "static_error_page_url_403" {
  description = "URL for the custom static error page for 403 errors"
  type        = string
}