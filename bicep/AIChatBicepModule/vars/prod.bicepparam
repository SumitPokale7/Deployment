// ============================================================================
// Production Environment Parameters - prod.bicepparam
// Migrated from Terraform: vars/prod.tfvars
// ============================================================================

using '../main.bicep'

// ============================================================================
// Common Parameters
// ============================================================================

param location = 'centralus'
param environment = 'prod'
param subscriptionId = '94f0eebc-4d31-4d69-bc92-dfc97103744a'

// ============================================================================
// Tags
// ============================================================================

param cmdbAssetTag = '000091958'
param cmdbFriendlyName = 'Trustage AI Services'
param cmdbOwnedBy = 'Ramesh, Rajeev (rrf8031)'
param cmdbOwnedByEmail = 'Rajeev.Ramesh@trustage.com'
param cmdbPortfolio = ''

// ============================================================================
// Networking Parameters
// ============================================================================

param vnetName = 'vnet-p01-ai-cognitive-tf'
param agwafNsgName = 'nsg-p01-ai-cognitive-agwaf-tf'
param privateEndpointNsgName = 'nsg-p01-ai-cognitive-privateendpoint-tf'
param privateEndpointSubnetName = 'pe_subnet'
param acaSubnetName = 'ca-p01-ai-cognitive-pe-subnet-tf'
param agwafPublicIpName = 'pip-p01-ai-cognitive-agwaf-tf'
param frontendNsgName = 'nsg-p01-ai-cognitive-frontend-tf'
param backendNsgName = 'nsg-p01-ai-cognitive-backend-tf'

// ============================================================================
// Monitoring Parameters
// ============================================================================

param aisName = 'ais-p01-ai-cognitive-tf'
param acaLogAnalyticsWorkspaceName = 'law-p01-ai-cognitive-tf'

// ============================================================================
// Storage Parameters
// ============================================================================

param storageName = 'sap01aicognitivetf'
param blobContainer = 'email-classifier-data'
param backEndCorsTrustage = 'https://chat.trustage.com'
param investmentStorageName = 'sap01invaicognitivetf'

// ============================================================================
// Cosmos DB Parameters
// ============================================================================

param cosmosdbAccountName = 'cdbacct-p01-ai-cognitive-tf'
param cosmosdbName = 'cdb-p01-ai-cognitive-tf'
param secondaryDbLocation = 'westus'
param cosmosdbEndpointName = 'pe-p01-ai-cognitive-cdb-tf'
param cosmosPrivateServiceConnectionName = 'psc-cdb-p01-ai-cognitive-tf'
param cosmosOpenaiPrivateDnsZoneName = 'privatelink.documents.azure.com'
param azurermPrivateDnsZoneVirtualNetworkLinkCosmos = 'pdnslink-p01-ai-cognitive-cosmos-tf'

// ============================================================================
// Search Parameters
// ============================================================================

param searchServiceName = 'ssvc-p01-ai-cognitive-tf'
param searchPrivateEndpointName = 'pe-p01-ai-cognitive-ssvc-tf'
param searchPrivateServiceConnectionName = 'psc-p01-ai-cognitive-ssvc-tf'
param searchPrivateDnsZoneName = 'privatelink.search.windows.net'
// param azurermPrivateDnsZoneVirtualNetworkLinkSearch = 'pdnslink-p01-ai-cognitive-ssvc-tf' # No resources were found in the Azure resource group.

// ============================================================================
// Cognitive Services - Form Recognizer Parameters
// ============================================================================

param formRecognizerName = 'fr-p01-ai-cognitive-tf'
param formRecognizerLocation = 'eastus'
param formRecognizerSubdomainName = 'fr-p01-truchat'
param documentIntelligenceOpenaiPrivateDnsZoneName = 'privatelink.cognitiveservices.azure.com'
param documentPrivateEndpointName = 'pe-p01-ai-cognitive-fr-tf'
param documentReaderServiceConnectionName = 'psc-p01-ai-cognitive-fr-tf'
param azurermPrivateFrDnsZoneVirtualNetworkLink = 'pdnslink-p01-ai-cognitive-fr-tf'
param embeddingQuota = '100'

// ============================================================================
// Cognitive Services - Translator Parameters
// ============================================================================

param translatorName = 'tr-p01-ai-cognitive-tf'
param translatorLocation = 'centralus'
param translatorSubdomainName = 'tr-p01-ai-cognitive-tf'
param translatorPrivateEndpointName = 'pe-p01-ai-cognitive-tr-tf'
param translatorPrivateServiceConnectionName = 'psc-p01-ai-cognitive-tr-tf'

// ============================================================================
// OpenAI Parameters
// ============================================================================

param openaiPrivateDnsZoneName = 'privatelink.openai.azure.com'
param azurermPrivateDnsZoneVirtualNetworkLinkOpenai = 'pdnslink-p01-ai-cognitive-oai-tf'

param openaiAccounts = {
  eastus2: {
    name: 'oai-p01-ai-cognitive-eastus2-tf'
    location: 'eastus2'
    sku_name: 'S0'
    subdomain_name: 'oai-p01-eastus2-truchat'
    private_endpoint_name: 'pe-p01-ai-cognitive-eastus2-oai-tf'
    private_service_connection_name: 'psc-p01-ai-cognitive-eastus2-oai-tf'
    models: {
      text_embedding_ada_002: {
        deployment_name: 'embedding'
        model_name: 'text-embedding-ada-002'
        sku_name: 'Standard'
        capacity: 175
      }
      gpt_4_1: {
        deployment_name: 'gpt-4.1'
        model_name: 'gpt-4.1'
        sku_name: 'GlobalStandard'
        capacity: 1000
      }
      gpt_4_1_excel_parser: {
        deployment_name: 'gpt-4.1-excel-parser'
        model_name: 'gpt-4.1'
        sku_name: 'GlobalStandard'
        capacity: 1500
      }
      model_router: {
        deployment_name: 'model-router'
        model_name: 'model-router'
        sku_name: 'GlobalStandard'
        capacity: 200
      }
    }
  }
}

// ============================================================================
// Key Vault Parameters
// ============================================================================

param keyVaultName = 'kv-p01-ai-cognitive-tf'
param frontEndCertKvName = 'kv-atlas-itportfolio-p'
param frontEndCertKvResourceGroupName = 'rg-cmfg-p01-psa-cognitiveservices-tf'
param frontEndAzurermAppServiceCertificateName = 'chat-trustage-cert-secret'
param frontEndAzurermAppServiceCertificatePassword = 'chat-trustage-cert-password'
param frontEndHostName = 'chat.trustage.com'
param frontEndCertId = 'https://kv-atlas-itportfolio-p.vault.azure.net:443/certificates/trupilot-trustage-cert'

// ============================================================================
// Container Apps Parameters
// ============================================================================

param acrName = 'acraiservicesprod'
param acrSku = 'Premium'
param deployAcr = true  // ACR needs to be deployed in prod
param acaEnvName = 'managed-private-environment-tf'
param acaInfrastructureResourceGroupName = 'ME_managed-private-environment-tf_rg-cmfg-p01-psa-cognitiveservices-tf_centralus'
param acaEnvPrivateEndpointName = 'pe-p01-ai-cognitive-aca-env-tf'
param acaPrivateEndpointConnectionName = 'psc-p01-ai-cognitive-aca-env-tf'
param acaPrivateDnsZoneVirtualNetworkLinkName = 'pdnslink-p01-ai-cognitive-aca-tf' // No resources were found in the Azure resource group.

param containerApps = {
  translation_api: {
    name: 'ca-p01-ai-translationapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/api/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_request_timeout: 120
    agw_path_patterns: ['/translationapi/*']
    agw_rewrite_enabled: true
    agw_rewrite_pattern: '/translationapi/(.*)'
    agw_rewrite_path: '/{var_uri_path_1}'
    agw_rewrite_sequence: 12
  }
  CommercialMailBox_API: {
    name: 'ca-p01-ai-mailboxapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '0.5'
    memory: '1Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/api/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_path_patterns: ['/mailboxapi/*']
    agw_rewrite_enabled: true
    agw_rewrite_pattern: '/mailboxapi/(.*)'
    agw_rewrite_path: '/{var_uri_path_1}'
    agw_rewrite_sequence: 12
  }
  chat_app_frontend: {
    name: 'ca-p01-ai-chatapp-frontend-tf'
    revision_mode: 'Single'
    target_port: 80
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 80
    liveness_probe_path: '/'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_path_patterns: ['/*']
  }
  chat_app_backend: {
    name: 'ca-p01-ai-chatapp-backend-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '2'
    memory: '4Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/chatapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/chatapi/*']
  }
  chatkmstrainingapi: {
    name: 'ca-p01-ai-chatkmstrainingapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '3'
    memory: '6Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/chatkmstrainingapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/chatkmstrainingapi/*']
  }
}

// ============================================================================
// Application Gateway Parameters
// ============================================================================

param agwafName = 'agwaf-p01-ai-cognitive-tf'
param blackListedCountries = []  // Dynamically injected from Atlas constants.ps1
param backendAddressPoolFrontend = 'as-p01-ai-cognitive-truchat-frontend-tf.azurewebsites.net'
param backendAddressPoolFrontendInv = 'as-p01-ai-inv-cognitive-truchat-frontend-tf.azurewebsites.net'
param backendAddressPoolBackend = 'as-p01-ai-cognitive-truchat-backend-tf.azurewebsites.net'
param backendAddressPoolBackendInv = 'as-p01-ai-inv-cognitive-truchat-backend-tf.azurewebsites.net'
param backendAddressPoolBackendResearch = ''
param backendAddressPoolFrontendResearch = ''
param apimIp = '20.94.116.235'  // Prod APIM IP
param staticErrorPageUrl403 = 'https://sap01aicognitivetf.z19.web.core.windows.net/index.html'
