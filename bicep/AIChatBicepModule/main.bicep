// ============================================================================
// Main Orchestration File - main.bicep
// Migrated from Terraform OpenAITFModule
// This file orchestrates all the modules for the AI Chat Application
// ============================================================================

targetScope = 'resourceGroup'

// ============================================================================
// Common Parameters (matching Terraform variables.tf)
// ============================================================================

@description('Location for all resources')
param location string

@description('Environment name (dev, demo, prod)')
@allowed(['dev', 'demo', 'prod'])
param environment string

@description('Subscription ID')
#disable-next-line no-unused-params
param subscriptionId string

// ============================================================================
// Tags (matching Terraform locals.trustage_tags)
// ============================================================================

@description('CMDB Asset Tag')
param cmdbAssetTag string

@description('CMDB Friendly Name')
param cmdbFriendlyName string

@description('CMDB Owned By')
param cmdbOwnedBy string

@description('CMDB Owned By Email')
param cmdbOwnedByEmail string

@description('CMDB Portfolio')
param cmdbPortfolio string = ''

var tags = {
  cmdbAssetTag: cmdbAssetTag
  cmdbFriendlyName: cmdbFriendlyName
  cmdbOwnedBy: cmdbOwnedBy
  cmdbOwnedByEmail: cmdbOwnedByEmail
  cmdbPortfolio: cmdbPortfolio
}

// ============================================================================
// Networking Parameters
// ============================================================================

@description('Name of the Virtual Network')
param vnetName string

@description('Name of the Application Gateway WAF NSG')
param agwafNsgName string

@description('Name of the Private Endpoint NSG')
param privateEndpointNsgName string

@description('Name of the Private Endpoint subnet')
param privateEndpointSubnetName string

@description('Name of the Container Apps subnet')
param acaSubnetName string

@description('Name of the Public IP for Application Gateway')
param agwafPublicIpName string

@description('NSG name for the front end webapp')
#disable-next-line no-unused-params
param frontendNsgName string

@description('NSG name for the back end webapp')
#disable-next-line no-unused-params
param backendNsgName string

// ============================================================================
// Monitoring Parameters
// ============================================================================

@description('Name of the Application Insights resource')
param aisName string

@description('Name of the Log Analytics Workspace')
param acaLogAnalyticsWorkspaceName string

// ============================================================================
// Storage Parameters
// ============================================================================

@description('Name of the storage account')
param storageName string

@description('Name of the blob container')
param blobContainer string

@description('CORS allowed origin for storage')
param backEndCorsTrustage string

@description('Investment storage account name (optional)')
#disable-next-line no-unused-params
param investmentStorageName string = ''

// ============================================================================
// Cosmos DB Parameters
// ============================================================================

@description('Name of the Cosmos DB account')
param cosmosdbAccountName string

@description('Name of the Cosmos DB SQL database')
param cosmosdbName string

@description('Secondary location for Cosmos DB')
param secondaryDbLocation string

@description('Name of the Cosmos DB private endpoint')
param cosmosdbEndpointName string

@description('Cosmos DB private service connection name')
#disable-next-line no-unused-params
param cosmosPrivateServiceConnectionName string

@description('Name of the Cosmos DB private DNS zone')
param cosmosOpenaiPrivateDnsZoneName string

@description('Name of the Cosmos DB DNS zone virtual network link')
param azurermPrivateDnsZoneVirtualNetworkLinkCosmos string

// ============================================================================
// Search Parameters
// ============================================================================

@description('Name of the Azure AI Search service')
param searchServiceName string

@description('Name of the Search private endpoint')
param searchPrivateEndpointName string

@description('Name for the search private service connection')
param searchPrivateServiceConnectionName string

@description('Name of the Search private DNS zone')
param searchPrivateDnsZoneName string

@description('Name for the Search DNS zone virtual network link')
param azurermPrivateDnsZoneVirtualNetworkLinkSearch string

// ============================================================================
// Cognitive Services - Form Recognizer Parameters
// ============================================================================

@description('Name of the Form Recognizer cognitive account')
param formRecognizerName string

@description('Location for Form Recognizer')
param formRecognizerLocation string

@description('Custom subdomain name for Form Recognizer')
param formRecognizerSubdomainName string

@description('DNS zone name for form recognizer')
param documentIntelligenceOpenaiPrivateDnsZoneName string

@description('Name for Form Recognizer private endpoint')
param documentPrivateEndpointName string

@description('Name for the form recognizer service connection name')
#disable-next-line no-unused-params
param documentReaderServiceConnectionName string

@description('Name for the form recognizer dns zone virtual link')
param azurermPrivateFrDnsZoneVirtualNetworkLink string

@description('Quota for embedding model')
param embeddingQuota string

// ============================================================================
// Cognitive Services - Translator Parameters
// ============================================================================

@description('Name of the Translator cognitive account')
param translatorName string

@description('Location for Translator')
param translatorLocation string

@description('Custom subdomain name for Translator')
param translatorSubdomainName string

@description('Name for Translator private endpoint')
param translatorPrivateEndpointName string

@description('Name for Translator private service connection')
param translatorPrivateServiceConnectionName string

// ============================================================================
// Cognitive Services - OpenAI Parameters
// ============================================================================

@description('Name of the OpenAI private DNS zone')
param openaiPrivateDnsZoneName string

@description('Name for the OpenAI DNS zone virtual network link')
param azurermPrivateDnsZoneVirtualNetworkLinkOpenai string

@description('OpenAI accounts configuration')
param openaiAccounts object

// ============================================================================
// Key Vault Parameters
// ============================================================================

@description('Name of the Key Vault')
param keyVaultName string

@description('Front end cert Key Vault name')
#disable-next-line no-unused-params
param frontEndCertKvName string

@description('Front end cert Key Vault resource group name')
#disable-next-line no-unused-params
param frontEndCertKvResourceGroupName string

@description('Front end certificate name')
#disable-next-line no-unused-params
param frontEndAzurermAppServiceCertificateName string

@description('Front end certificate password secret name')
@secure()
#disable-next-line no-unused-params
param frontEndAzurermAppServiceCertificatePassword string

@description('Front end host name')
#disable-next-line no-unused-params
param frontEndHostName string

@description('Front end certificate ID')
#disable-next-line no-unused-params
param frontEndCertId string

// ============================================================================
// Container Apps Parameters
// ============================================================================

@description('Name of the Azure Container Registry')
#disable-next-line no-unused-params
param acrName string = ''

@description('ACR SKU')
#disable-next-line no-unused-params
param acrSku string = 'Standard'

@description('Deploy ACR (only in dev/prod)')
#disable-next-line no-unused-params
param deployAcr bool = true

@description('Name of the Container App Environment')
param acaEnvName string

@description('Infrastructure resource group name for Container App Environment')
param acaInfrastructureResourceGroupName string

@description('Name of the Container App Environment private endpoint')
#disable-next-line no-unused-params
param acaEnvPrivateEndpointName string

@description('Name for the Container Apps private endpoint connection')
#disable-next-line no-unused-params
param acaPrivateEndpointConnectionName string

@description('Name for the Container Apps DNS zone virtual network link')
#disable-next-line no-unused-params
param acaPrivateDnsZoneVirtualNetworkLinkName string

@description('Container apps configuration')
param containerApps object

// ============================================================================
// Application Gateway Parameters
// ============================================================================

@description('Name of the Application Gateway')
param agwafName string

@description('Blacklisted countries for geo-blocking')
param blackListedCountries array

@description('Backend address pool FQDN for frontend')
#disable-next-line no-unused-params
param backendAddressPoolFrontend string

@description('Backend address pool FQDN for frontend inv')
#disable-next-line no-unused-params
param backendAddressPoolFrontendInv string

@description('Backend address pool FQDN for backend')
#disable-next-line no-unused-params
param backendAddressPoolBackend string

@description('Backend address pool FQDN for backend inv')
#disable-next-line no-unused-params
param backendAddressPoolBackendInv string

@description('Backend address pool FQDN for backend research')
#disable-next-line no-unused-params
param backendAddressPoolBackendResearch string

@description('Backend address pool FQDN for frontend research')
#disable-next-line no-unused-params
param backendAddressPoolFrontendResearch string

@description('APIM IP address')
#disable-next-line no-unused-params
param apimIp string

@description('Static error page URL for 403')
#disable-next-line no-unused-params
param staticErrorPageUrl403 string

// ============================================================================
// Module Deployments
// ============================================================================

// 1. Networking Module
module networking 'networking.bicep' = {
  name: 'networking-deployment'
  params: {
    location: location
    tags: tags
    vnetName: vnetName
    agwafNsgName: agwafNsgName
    privateEndpointNsgName: privateEndpointNsgName
    privateEndpointSubnetName: privateEndpointSubnetName
    containerAppSubnetName: acaSubnetName
    publicIpName: agwafPublicIpName
  }
}

// 2. Monitoring Module
module monitoring 'monitoring.bicep' = {
  name: 'monitoring-deployment'
  params: {
    location: location
    tags: tags
    applicationInsightsName: aisName
    logAnalyticsWorkspaceName: acaLogAnalyticsWorkspaceName
  }
}

// 3. Storage Module
module storage 'storage.bicep' = {
  name: 'storage-deployment'
  params: {
    location: location
    tags: tags
    storageAccountName: storageName
    blobContainerName: blobContainer
    corsAllowedOrigins: !empty(backEndCorsTrustage) ? [backEndCorsTrustage] : []
  }
}

// 4. Key Vault Module
module vault 'vault.bicep' = {
  name: 'vault-deployment'
  params: {
    location: location
    tags: tags
    keyVaultName: keyVaultName
  }
}

// 5. Cosmos DB Module
module cosmos 'cosmos.bicep' = {
  name: 'cosmos-deployment'
  params: {
    location: location
    tags: tags
    cosmosDbAccountName: cosmosdbAccountName
    cosmosDbDatabaseName: cosmosdbName
    secondaryDbLocation: secondaryDbLocation
    cosmosDbPrivateEndpointName: cosmosdbEndpointName
    cosmosDbDnsZoneLinkName: azurermPrivateDnsZoneVirtualNetworkLinkCosmos
    cosmosDbDnsZoneName: cosmosOpenaiPrivateDnsZoneName
    privateEndpointSubnetId: networking.outputs.privateEndpointSubnetId
    virtualNetworkId: networking.outputs.vnetId
  }
}

// 7. Search Module
module search 'search.bicep' = {
  name: 'search-deployment'
  params: {
    location: location
    tags: tags
    searchServiceName: searchServiceName
    searchPrivateEndpointName: searchPrivateEndpointName
    searchPrivateServiceConnectionName: searchPrivateServiceConnectionName
    searchDnsZoneName: searchPrivateDnsZoneName
    privateEndpointSubnetId: networking.outputs.privateEndpointSubnetId
    searchDnsZoneLinkName: azurermPrivateDnsZoneVirtualNetworkLinkSearch
    virtualNetworkId: networking.outputs.vnetId
  }
}

// 8. Cognitive Services Module
module cognitive 'cognitive.bicep' = {
  name: 'cognitive-deployment'
  params: {
    location: location
    tags: tags
    formRecognizerName: formRecognizerName
    formRecognizerLocation: formRecognizerLocation
    formRecognizerSubdomainName: formRecognizerSubdomainName
    translatorName: translatorName
    translatorLocation: translatorLocation
    translatorSubdomainName: translatorSubdomainName
    formRecognizerPrivateEndpointName: documentPrivateEndpointName
    formRecognizerPrivateServiceConnectionName: documentReaderServiceConnectionName
    translatorPrivateEndpointName: translatorPrivateEndpointName
    translatorPrivateServiceConnectionName: translatorPrivateServiceConnectionName
    cognitiveServicesDnsZoneName: documentIntelligenceOpenaiPrivateDnsZoneName
    cognitiveServicesDnsZoneLinkName: azurermPrivateFrDnsZoneVirtualNetworkLink
    openAIDnsZoneName: openaiPrivateDnsZoneName
    openAIDnsZoneLinkName: azurermPrivateDnsZoneVirtualNetworkLinkOpenai
    privateEndpointSubnetId: networking.outputs.privateEndpointSubnetId
    virtualNetworkId: networking.outputs.vnetId
    openaiAccounts: openaiAccounts
    embeddingQuota: embeddingQuota
  }
}

// 9. Container Apps Module
module containerapp 'containerapp.bicep' = {
  name: 'containerapp-deployment'
  params: {
    location: location
    tags: tags
    environment: environment
    acrName: environment == 'prod' ? 'acraiservicesprod' : 'acraiservicesnonprod'
    deployAcr: environment == 'dev' || environment == 'prod'
    containerAppEnvName: acaEnvName
    containerAppSubnetId: networking.outputs.containerAppSubnetId
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsWorkspaceId
    logAnalyticsCustomerId: monitoring.outputs.logAnalyticsCustomerId
    infrastructureResourceGroupName: acaInfrastructureResourceGroupName
    containerAppsDnsZoneLinkName: acaPrivateDnsZoneVirtualNetworkLinkName
    containerAppEnvPrivateEndpointName: acaEnvPrivateEndpointName
    privateEndpointSubnetId: networking.outputs.privateEndpointSubnetId
    virtualNetworkId: networking.outputs.vnetId
    containerApps: containerApps
  }
}

// 10. Application Gateway WAF Module
module agwaf 'agwaf.bicep' = {
  name: 'agwaf-deployment'
  params: {
    location: location
    tags: tags
    applicationGatewayName: agwafName
    agwafSubnetId: networking.outputs.agwafSubnetId
    publicIpId: networking.outputs.publicIpId
    environment: environment
    blackListedCountries: blackListedCountries
    apimIp: apimIp
    containerApps: containerApps
    containerAppEnvironmentDomain: containerapp.outputs.containerAppEnvDefaultDomain
    containerAppEnvironmentStaticIp: containerapp.outputs.containerAppEnvStaticIp
    // Investment backend pools (not deployed in dev)
    backendAddressPoolFrontendInv: backendAddressPoolFrontendInv
    backendAddressPoolBackendInv: backendAddressPoolBackendInv
    // Storage names for CSP headers
    storageName: storageName
    investmentStorageName: investmentStorageName
    // Static error page
    staticErrorPageUrl403: staticErrorPageUrl403
  }
}

// 11. Coco Cognitive Services Module
module cocoCognitive './coco-cognitive.bicep' = {
  name: 'coco-cognitive-module'
  params: {
    environment: environment
  }
}

// ============================================================================
// Outputs
// ============================================================================

output vnetId string = networking.outputs.vnetId
output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
output applicationInsightsConnectionString string = monitoring.outputs.applicationInsightsConnectionString
output storageAccountId string = storage.outputs.storageAccountId
output keyVaultUri string = vault.outputs.keyVaultUri
output cosmosDbEndpoint string = cosmos.outputs.cosmosDbEndpoint
output searchServiceEndpoint string = search.outputs.searchServiceEndpoint
output openAIEndpoints array = cognitive.outputs.openAIEndpoints
output formRecognizerEndpoint string = cognitive.outputs.formRecognizerEndpoint
output translatorEndpoint string = cognitive.outputs.translatorEndpoint
output containerAppEnvId string = containerapp.outputs.containerAppEnvId
output applicationGatewayId string = agwaf.outputs.applicationGatewayId
