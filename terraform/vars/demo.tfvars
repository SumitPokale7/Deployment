# azure platform information
resource_group_name = "rg-cmfg-m01-psa-cognitiveservices-tf"
subscription_id = "059ed1ab-6824-4344-9a65-a0504248340f"
environment = "demo"
# primary resouce location
location = "centralus"

#cosmos db
secondary_db_location = "westus"
cosmosdb_name = "cdb-m01-ai-cognitive-tf"
cosmosdb_endpoint_name = "pe-m01-ai-cognitive-cdb-tf"
cosmos_private_service_connection_name = "psc-cdb-m01-ai-cognitive-tf"
private_endpoint_subnet_name = "cdb-m01-ai-cognitive-pe-subnet-tf"
cosmos_openai_private_dns_zone_name = "privatelink.documents.azure.com"
cosmosdb_account_name = "cdbacct-m01-ai-cognitive-tf"
azurerm_private_dns_zone_virtual_network_link_cosmos = "pdnslink-m01-ai-cognitive-cosmos-tf"
# virtual network
vnet_name = "vnet-m01-ai-cognitive-tf"

## front end
frontend_nsg_name = "nsg-m01-ai-cognitive-frontend-tf"
front_end_endpoint_name = "pe-m01-ai-cognitive-frontend-tf"
app_services_private_dns_zone_name = "privatelink.frontend.windows.net"
azurerm_private_dns_zone_virtual_network_link_app_services = "pdnslink-m01-ai-cognitive-frontend-tf"
## back end
backend_nsg_name = "nsg-m01-ai-cognitive-backend-tf"
private_endpoint_nsg_name = "nsg-m01-ai-cognitive-privateendpoint-tf"
back_end_endpoint_name = "pe-m01-ai-cognitive-backend-tf"

# web app
ais_name = "ais-m01-ai-cognitive-tf"
asp_name = "asp-m01-ai-cognitive-tf"
asp_Sku_name = "P0v3"
front_end_app_name = "as-m01-ai-cognitive-truchat-frontend-tf"
back_end_app_name = "as-m01-ai-cognitive-truchat-backend-tf"
back_end_cors_microsoft = "https://as-m01-ai-cognitive-truchat-frontend-tf.azurewebsites.net"
back_end_cors_trustage = "https://chatdemo.trustage.com"
managed_identity_name = "uami-m01-ai-cognitive-tf"
front_end_cert_id = "https://kv-atlas-itportfolio-np.vault.azure.net:443/certificates/truPilot-Trustagedev-cert/1ffcdfdb827846f5a59b6a11bfa62eae"
front_end_azurerm_app_service_certificate_name = "chatdemo-trustage-cert-secret"
front_end_azurerm_app_service_certificate_password = "chatdemo-trustage-cert-password"
front_end_host_name = "chatdemo.trustage.com"
front_end_cert_kv_name = "kv-m01-ai-cognitive-tf"
front_end_cert_kv_resource_group_name = "rg-cmfg-m01-psa-cognitiveservices-tf"

# container app
aca_subnet_name = "ca-m01-ai-cognitive-pe-subnet-tf"
aca_log_analytics_workspace_name = "law-m01-ai-cognitive-tf"
aca_env_private_endpoint_name = "pe-m01-ai-cognitive-aca-env-tf"
aca_private_endpoint_connection_name = "psc-m01-ai-cognitive-aca-env-tf"
aca_env_name = "managed-private-environment-tf"
aca_private_dns_zone_virtual_network_link_name = "pdnslink-m01-ai-cognitive-aca-tf"
aca_infrastructure_resource_group_name = "ME_managed-private-environment-tf_rg-cmfg-m01-psa-cognitiveservices-tf_centralus"

# search
search_sevice_name = "ssvc-m01-ai-cognitive-tf"
search_private_endpoint_name = "pe-m01-ai-cognitive-ssvc-tf"
search_private_service_connection_name = "psc-m01-ai-cognitive-ssvc-tf"
search_private_dns_zone_name = "privatelink.search.windows.net"
azurerm_private_dns_zone_virtual_network_link_search = "pdnslink-m01-ai-cognitive-ssvc-tf"

# form recognizer (document reader)
form_recognizer_name = "fr-m01-ai-cognitive-tf"
form_recognizer_subdomain_name = "fr-m01-truchat"
document_intelligenceopenai_private_dns_zone_name = "privatelink.cognitiveservices.azure.com"
document_reader_service_connection_name = "psc-m01-ai-cognitive-fr-tf"
document_private_endpoint_name = "pe-m01-ai-cognitive-fr-tf"
azurerm_private_fr_dns_zone_virtual_network_link = "pdnslink-m01-ai-cognitive-fr-tf"
form_recognizer_location = "westus2"
embedding_quota = "175"

# translator
translator_name = "tr-m01-ai-cognitive-tf"
translator_private_endpoint_name = "pe-m01-ai-cognitive-tr-tf"
translator_private_service_connection_name = "psc-m01-ai-cognitive-tr-tf"
translator_private_dns_zone_virtual_network_link_name = "pdnslink-m01-ai-cognitive-tr-tf"
translator_subdomain_name = "tr-m01-ai-cognitive-tf"
translator_location = "centralus"

# openai northcentralus
openai_name = "oai-m01-ai-cognitive-tf"
openai_location = "northcentralus"
openai_dns_a_record = "cog-lc22t6ddbanlc"
openai_private_dns_zone_name = "privatelink.openai.azure.com"
openai_private_endpoint_name = "pe-m01-ai-cognitive-oai-tf"
openai_private_service_connection_name = "psc-m01-ai-cognitive-oai-tf"
openai_subdomain_name = "oai-m01-truchat"
azurerm_private_dns_zone_virtual_network_link_openai = "pdnslink-m01-ai-cognitive-oai-tf"
gpt35version = "0613"
chat_capacity = "100"
openai4_1_chat_capacity = "200"
# openai eastus
openai_01_name = "oai-m01-ai-cognitive-eastus-tf"
openai_01_location = "eastus"
openai_01_private_endpoint_name = "pe-m01-ai-cognitive-eastus-oai-tf"
openai_01_private_service_connection_name = "psc-m01-ai-cognitive-eastus-cdb-tf"
openai_01_subdomain_name = "oai-m01-eastus-truchat"

# key vault
key_vault_name = "kv-m01-ai-cognitive-tf"

# agwaf
agwaf_azurerm_public_ip_name = "pip-m01-ai-cognitive-agwaf-tf"
agwaf_name = "agwaf-m01-ai-cognitive-tf"
agwaf_nsg_name = "nsg-m01-ai-cognitive-agwaf-tf"
backend_address_pool_frontend = "as-m01-ai-cognitive-truchat-frontend-tf.azurewebsites.net"
backend_address_pool_backend = "as-m01-ai-cognitive-truchat-backend-tf.azurewebsites.net"
backend_address_pool_frontend_inv = "as-m01-ai-inv-cognitive-truchat-frontend-tf.azurewebsites.net"
backend_address_pool_backend_inv = "as-m01-ai-inv-cognitive-truchat-backend-tf.azurewebsites.net"
backend_address_pool_backend_research = ""
backend_address_pool_frontend_research = ""
#Storage

storage_Name = "sam01aicognitivetf"
investment_storage_Name = "sam01invaicognitivetf"
blob_container ="email-classifier-data"

#Apim
apim_ip = "20.10.12.58" # demo APIM IP
# error page url
static_error_page_url_403 = "https://sam01aicognitivetf.z19.web.core.windows.net/index.html"
openai_accounts = {
  "eastus2" = {
    name                              = "oai-m01-ai-cognitive-eastus2-tf"
    location                          = "eastus2"
    sku_name                         = "S0"
    subdomain_name                   = "oai-m01-eastus2-truchat"
    private_endpoint_name            = "pe-m01-ai-cognitive-eastus2-oai-tf"
    private_service_connection_name  = "psc-m01-ai-cognitive-eastus2-oai-tf"
    models = {
      "text-embedding-ada-002" = {
        deployment_name = "embedding"
        model_name      = "text-embedding-ada-002"
        sku_name        = "Standard"
        capacity        = 175
      }
      "gpt-4.1" = {
        deployment_name = "gpt-4.1"
        model_name      = "gpt-4.1"
        sku_name        = "GlobalStandard"
        capacity        = 200
      }
      "gpt-4.1-excel-parser" = {
        deployment_name = "gpt-4.1-excel-parser"
        model_name      = "gpt-4.1"
        sku_name        = "GlobalStandard"
        capacity        = 500
      }
      # "gpt-5-mini" = {
      #   deployment_name = "gpt-5-mini"
      #   model_name      = "gpt-5-mini"
      #   sku_name        = "GlobalStandard"
      #   capacity        = 200
      # }
      # "gpt-5-nano" = {
      #   deployment_name = "gpt-5-nano"
      #   model_name      = "gpt-5-nano"
      #   sku_name        = "GlobalStandard"
      #   capacity        = 200
      # }
      "model-router" = {
        deployment_name = "model-router"
        model_name      = "model-router"
        sku_name        = "GlobalStandard"
        capacity        = 200
      }
    }
  }
}
container_apps = {
  "translation_api" = {
    name                         = "ca-m01-ai-translationapi-tf"
    revision_mode                = "Single"
    target_port                  = 8001
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "1"
    memory                       = "2Gi"
    liveness_probe_port          = 8001
    liveness_probe_path          = "/api/health"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 10
    # Application Gateway integration
    agw_enabled                  = true
    agw_request_timeout          = 120 
    agw_path_patterns            = ["/translationapi/*"]
    # URL Rewrite Configuration
    agw_rewrite_enabled         = true
    agw_rewrite_pattern         = "/translationapi/(.*)"
    agw_rewrite_path            = "/{var_uri_path_1}"
    agw_rewrite_sequence        = 12
  },
  "CommercialMailBox_API" = {
    name                         = "ca-m01-ai-mailboxapi-tf"
    revision_mode                = "Single"
    target_port                  = 8001
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "0.5"
    memory                       = "1Gi"
    liveness_probe_port          = 8001
    liveness_probe_path          = "/api/health"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 10
    # Application Gateway integration  
    agw_enabled                  = true
    agw_path_patterns            = ["/mailboxapi/*"]
    # URL Rewrite Configuration
    agw_rewrite_enabled         = true
    agw_rewrite_pattern         = "/mailboxapi/(.*)"
    agw_rewrite_path            = "/{var_uri_path_1}"
    agw_rewrite_sequence        = 12
  }
   # chat app frontend (SPA)
  "chat_app_frontend" = {
    name                         = "ca-m01-ai-chatapp-frontend-tf"
    revision_mode                = "Single"
    target_port                  = 80
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "0.5"
    memory                       = "1Gi"
    liveness_probe_port          = 80
    liveness_probe_path          = "/"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 10
    # Not exposed through Application Gateway (internal only)
    agw_enabled                  = true
    agw_path_patterns = ["/*"]#["/pilot/*"]
  }
  # chat app backend (API)
  "chat_app_backend" = {
    name                         = "ca-m01-ai-chatapp-backend-tf"
    revision_mode                = "Single"
    target_port                  = 8001
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "1"
    memory                       = "2Gi"
    liveness_probe_port          = 8001
    liveness_probe_path          = "/chatapi/health"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 10
    # Application Gateway integration
    agw_enabled                  = true
    agw_path_patterns = ["/chatapi/*"]
  }
  # /chatkmstrainingapi
  "chatkmstrainingapi" = {
    name                         = "ca-m01-ai-chatkmstrainingapi-tf"
    revision_mode                = "Single"
    target_port                  = 8001
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "2.75"
    memory                       = "5.5Gi"
    liveness_probe_port          = 8001
    liveness_probe_path          = "/chatkmstrainingapi/health"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 5
    # Application Gateway integration
    agw_enabled                  = true
    agw_path_patterns           = ["/chatkmstrainingapi/*"]
  }
   #core services api
  "core_services_api" = {
    name                         = "ca-m01-ai-coreservicesapi-tf"
    revision_mode                = "Single"
    target_port                  = 8001
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "1"
    memory                       = "2Gi"
    liveness_probe_port          = 8001
    liveness_probe_path          = "/coreservicesapi/health"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 5
    # Application Gateway integration
    agw_enabled                  = true
    agw_path_patterns           = ["/coreservicesapi/*"]
  }
  # inference api
  "inference_api" = {
    name                         = "ca-m01-ai-inferenceapi-tf"
    revision_mode                = "Single"
    target_port                  = 8001
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "1"
    memory                       = "2Gi"
    liveness_probe_port          = 8001
    liveness_probe_path          = "/inferenceapi/health"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 5
    # Application Gateway integration
    agw_enabled                  = true
    agw_path_patterns           = ["/inferenceapi/*"]
  }

  "document_ingestion_api" = {
    name                         = "ca-m01-ai-doc-ingestionapi-tf"
    revision_mode                = "Single"
    target_port                  = 8001
    image                        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu                          = "1"
    memory                       = "2Gi"
    liveness_probe_port          = 8001
    liveness_probe_path          = "/documentingestionapi/health"
    liveness_probe_transport     = "HTTP"
    min_replicas                 = 1
    max_replicas                 = 3
    max_inactive_revisions       = 5
    # Application Gateway integration
    agw_enabled                  = true
    agw_path_patterns           = ["/documentingestionapi/*"]
  }
}
# tags
cmdbAssetTag     = "000091958"
cmdbFriendlyName = "Trustage AI Services"
cmdbOwnedBy      = "Ramesh, Rajeev (rrf8031)"
cmdbOwnedByEmail = "Rajeev.Ramesh@trustage.com"
cmdbPortfolio    = ""
black_listed_countries = [__GEOBLOCK__]
