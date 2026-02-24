// ============================================================================
// Demo Environment Parameters - demo.bicepparam
// Migrated from Terraform: vars/demo.tfvars
// ============================================================================

using '../main.bicep'

// ============================================================================
// Common Parameters
// ============================================================================

param location = 'centralus'
param environment = 'demo'
param subscriptionId = '059ed1ab-6824-4344-9a65-a0504248340f'

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

param vnetName = 'vnet-m01-ai-cognitive-tf'
param agwafNsgName = 'nsg-m01-ai-cognitive-agwaf-tf'
param privateEndpointNsgName = 'nsg-m01-ai-cognitive-privateendpoint-tf'
param privateEndpointSubnetName = 'cdb-m01-ai-cognitive-pe-subnet-tf'
param acaSubnetName = 'ca-m01-ai-cognitive-pe-subnet-tf'
param agwafPublicIpName = 'pip-m01-ai-cognitive-agwaf-tf'
param frontendNsgName = 'nsg-m01-ai-cognitive-frontend-tf'
param backendNsgName = 'nsg-m01-ai-cognitive-backend-tf'

// ============================================================================
// Monitoring Parameters
// ============================================================================

param aisName = 'ais-m01-ai-cognitive-tf'
param acaLogAnalyticsWorkspaceName = 'law-m01-ai-cognitive-tf'

// ============================================================================
// Storage Parameters
// ============================================================================

param storageName = 'sam01aicognitivetf'
param blobContainer = 'email-classifier-data'
param backEndCorsTrustage = 'https://chatdemo.trustage.com'
param investmentStorageName = 'sam01invaicognitivetf'

// ============================================================================
// Cosmos DB Parameters
// ============================================================================

param cosmosdbAccountName = 'cdbacct-m01-ai-cognitive-tf'
param cosmosdbName = 'cdb-m01-ai-cognitive-tf'
param secondaryDbLocation = 'westus'
param cosmosdbEndpointName = 'pe-m01-ai-cognitive-cdb-tf'
param cosmosPrivateServiceConnectionName = 'psc-cdb-m01-ai-cognitive-tf'
param cosmosOpenaiPrivateDnsZoneName = 'privatelink.documents.azure.com'
param azurermPrivateDnsZoneVirtualNetworkLinkCosmos = 'pdnslink-m01-ai-cognitive-cosmos-tf'

// ============================================================================
// Search Parameters
// ============================================================================

param searchServiceName = 'ssvc-m01-ai-cognitive-tf'
param searchPrivateEndpointName = 'pe-m01-ai-cognitive-ssvc-tf'
param searchPrivateServiceConnectionName = 'psc-m01-ai-cognitive-ssvc-tf'
param searchPrivateDnsZoneName = 'privatelink.search.windows.net'
// param azurermPrivateDnsZoneVirtualNetworkLinkSearch = 'pdnslink-m01-ai-cognitive-ssvc-tf' # No resources were found in the Azure resource group.

// ============================================================================
// Cognitive Services - Form Recognizer Parameters
// ============================================================================

param formRecognizerName = 'fr-m01-ai-cognitive-tf'
param formRecognizerLocation = 'westus2'
param formRecognizerSubdomainName = 'fr-m01-truchat'
param documentIntelligenceOpenaiPrivateDnsZoneName = 'privatelink.cognitiveservices.azure.com'
param documentPrivateEndpointName = 'pe-m01-ai-cognitive-fr-tf'
param documentReaderServiceConnectionName = 'psc-m01-ai-cognitive-fr-tf'
param azurermPrivateFrDnsZoneVirtualNetworkLink = 'pdnslink-m01-ai-cognitive-fr-tf'
param embeddingQuota = '175'

// ============================================================================
// Cognitive Services - Translator Parameters
// ============================================================================

param translatorName = 'tr-m01-ai-cognitive-tf'
param translatorLocation = 'centralus'
param translatorSubdomainName = 'tr-m01-ai-cognitive-tf'
param translatorPrivateEndpointName = 'pe-m01-ai-cognitive-tr-tf'
param translatorPrivateServiceConnectionName = 'psc-m01-ai-cognitive-tr-tf'

// ============================================================================
// OpenAI Parameters
// ============================================================================

param openaiPrivateDnsZoneName = 'privatelink.openai.azure.com'
param azurermPrivateDnsZoneVirtualNetworkLinkOpenai = 'pdnslink-m01-ai-cognitive-oai-tf'

param openaiAccounts = {
  eastus2: {
    name: 'oai-m01-ai-cognitive-eastus2-tf'
    location: 'eastus2'
    sku_name: 'S0'
    subdomain_name: 'oai-m01-eastus2-truchat'
    private_endpoint_name: 'pe-m01-ai-cognitive-eastus2-oai-tf'
    private_service_connection_name: 'psc-m01-ai-cognitive-eastus2-oai-tf'
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
        capacity: 200
      }
      gpt_4_1_excel_parser: {
        deployment_name: 'gpt-4.1-excel-parser'
        model_name: 'gpt-4.1'
        sku_name: 'GlobalStandard'
        capacity: 500
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

param keyVaultName = 'kv-m01-ai-cognitive-tf'
param frontEndCertKvName = 'kv-m01-ai-cognitive-tf'
param frontEndCertKvResourceGroupName = 'rg-cmfg-m01-psa-cognitiveservices-tf'
param frontEndAzurermAppServiceCertificateName = 'chatdemo-trustage-cert-secret'
param frontEndAzurermAppServiceCertificatePassword = 'chatdemo-trustage-cert-password'
param frontEndHostName = 'chatdemo.trustage.com'
param frontEndCertId = 'https://kv-atlas-itportfolio-np.vault.azure.net:443/certificates/truPilot-Trustagedev-cert/1ffcdfdb827846f5a59b6a11bfa62eae'

// ============================================================================
// Container Apps Parameters
// ============================================================================

param acrName = 'acraiservicesnonprod'
param acrSku = 'Standard'
param deployAcr = false  // ACR already exists in demo
param acaEnvName = 'managed-private-environment-tf'
param acaInfrastructureResourceGroupName = 'ME_managed-private-environment-tf_rg-cmfg-m01-psa-cognitiveservices-tf_centralus'
param acaEnvPrivateEndpointName = 'pe-m01-ai-cognitive-aca-env-tf'
param acaPrivateEndpointConnectionName = 'psc-m01-ai-cognitive-aca-env-tf'
param acaPrivateDnsZoneVirtualNetworkLinkName = 'pdnslink-m01-ai-cognitive-aca-tf' // No resources were found in the Azure resource group.

param containerApps = {
  translation_api: {
    name: 'ca-m01-ai-translationapi-tf'
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
    name: 'ca-m01-ai-mailboxapi-tf'
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
    name: 'ca-m01-ai-chatapp-frontend-tf'
    revision_mode: 'Single'
    target_port: 80
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '0.5'
    memory: '1Gi'
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
    name: 'ca-m01-ai-chatapp-backend-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/chatapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_path_patterns: ['/chatapi/*']
  }
  chatkmstrainingapi: {
    name: 'ca-m01-ai-chatkmstrainingapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '2.75'
    memory: '5.5Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/chatkmstrainingapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/chatkmstrainingapi/*']
  }
  core_services_api: {
    name: 'ca-m01-ai-coreservicesapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/coreservicesapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/coreservicesapi/*']
  }
  inference_api: {
    name: 'ca-m01-ai-inferenceapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/inferenceapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/inferenceapi/*']
  }
  document_ingestion_api: {
    name: 'ca-m01-ai-doc-ingestionapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/documentingestionapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/documentingestionapi/*']
  }
}

// ============================================================================
// Application Gateway Parameters
// ============================================================================

param agwafName = 'agwaf-m01-ai-cognitive-tf'
param blackListedCountries = []  // Dynamically injected from Atlas constants.ps1
param backendAddressPoolFrontend = 'as-m01-ai-cognitive-truchat-frontend-tf.azurewebsites.net'
param backendAddressPoolFrontendInv = 'as-m01-ai-inv-cognitive-truchat-frontend-tf.azurewebsites.net'
param backendAddressPoolBackend = 'as-m01-ai-cognitive-truchat-backend-tf.azurewebsites.net'
param backendAddressPoolBackendInv = 'as-m01-ai-inv-cognitive-truchat-backend-tf.azurewebsites.net'
param backendAddressPoolBackendResearch = ''
param backendAddressPoolFrontendResearch = ''
param apimIp = '20.10.12.58'  // Demo APIM IP
param staticErrorPageUrl403 = 'https://sam01aicognitivetf.z19.web.core.windows.net/index.html'
