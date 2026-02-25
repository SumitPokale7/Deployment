// ============================================================================
// Azure AI Search Module - search.bicep
// Matches Terraform: search.tf
// Contains: Azure AI Search Service, Private Endpoint, DNS Zone
// ============================================================================

@description('Location for the search resources')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Name of the Azure AI Search service')
param searchServiceName string

@description('SKU for the search service')
@allowed(['free', 'basic', 'standard', 'standard2', 'standard3', 'storage_optimized_l1', 'storage_optimized_l2'])
param searchSku string = 'basic'

@description('Number of replicas')
param replicaCount int = 1

@description('Number of partitions')
param partitionCount int = 1

@description('Hosting mode')
@allowed(['default', 'highDensity'])
param hostingMode string = 'default'

@description('Enable private endpoint')
param enablePrivateEndpoint bool = true

@description('Subnet ID for private endpoint')
param privateEndpointSubnetId string = ''

@description('Name of the private endpoint')
param searchPrivateEndpointName string = ''

@description('Name for Search private service connection')
param searchPrivateServiceConnectionName string = ''

@description('Search private DNS zone name')
param searchDnsZoneName string = 'privatelink-search-windows-net'

@description('Virtual network ID for DNS zone link')
param virtualNetworkId string = ''

@description('Name for DNS zone virtual network link')
param searchDnsZoneLinkName string = ''

// ============================================================================
// Azure AI Search Service
// ============================================================================

resource searchService 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: searchServiceName
  location: location
  tags: tags
  sku: {
    name: searchSku
  }
  properties: {
    replicaCount: replicaCount
    partitionCount: partitionCount
    hostingMode: hostingMode
    publicNetworkAccess: enablePrivateEndpoint ? 'Disabled' : 'Enabled'
    networkRuleSet: {
      ipRules: []
      bypass: 'None'
    }
    encryptionWithCmk: {
      enforcement: 'Disabled'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
      aadOrApiKey: {
        aadAuthFailureMode: 'http403'
      }
    }
    semanticSearch: 'free'
  }
}

// ============================================================================
// Private DNS Zone
// ============================================================================

resource searchDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = if (enablePrivateEndpoint) {
  name: searchDnsZoneName
  location: 'global'
  tags: tags
}

// ============================================================================
// DNS Zone Virtual Network Link
// ============================================================================

resource searchDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (enablePrivateEndpoint && !empty(virtualNetworkId)) {
  parent: searchDnsZone
  name: searchDnsZoneLinkName
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}

// ============================================================================
// Private Endpoint
// ============================================================================

resource searchPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  name: searchPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: searchPrivateServiceConnectionName
        properties: {
          privateLinkServiceId: searchService.id
          groupIds: ['searchService']
          requestMessage: ''
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpointSubnetId
    }
    ipConfigurations: []
  }
}

// ============================================================================
// Private DNS Zone Group
// ============================================================================

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  parent: searchPrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-search-windows-net'
        properties: {
          privateDnsZoneId: searchDnsZone.id
        }
      }
    ]
  }
}

// ============================================================================
// Outputs
// ============================================================================

output searchServiceId string = searchService.id
output searchServiceName string = searchService.name
output searchServiceEndpoint string = 'https://${searchService.name}.search.windows.net'
output searchServicePrincipalId string = searchService.identity.principalId
output privateEndpointId string = enablePrivateEndpoint && !empty(privateEndpointSubnetId) ? searchPrivateEndpoint.id : ''
