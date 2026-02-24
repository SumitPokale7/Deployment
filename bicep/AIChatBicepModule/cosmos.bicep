// ============================================================================
// Cosmos DB Module - cosmos.bicep
// Matches Terraform: cosmos.tf
// Contains: Cosmos DB Account, SQL Database, Private Endpoint, DNS Zone
// ============================================================================

@description('Location for the Cosmos DB resources')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Name of the Cosmos DB account')
param cosmosDbAccountName string

@description('Name of the SQL database')
param cosmosDbDatabaseName string

@description('Failover location for Cosmos DB')
#disable-next-line no-unused-params
param secondaryDbLocation string = 'westus'

@description('Enable private endpoint for Cosmos DB')
param enablePrivateEndpoint bool = true

@description('Subnet ID for private endpoint')
param privateEndpointSubnetId string = ''

@description('Name of the private endpoint')
param cosmosDbPrivateEndpointName string = ''

@description('Cosmos DB private DNS zone name')
param cosmosDbDnsZoneName string = 'privatelink.documents.azure.com'

@description('Virtual network ID for DNS zone link')
param virtualNetworkId string = ''

@description('Name for DNS zone virtual network link')
param cosmosDbDnsZoneLinkName string = ''

// ============================================================================
// Cosmos DB Account
// ============================================================================

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-08-15' = {
  name: cosmosDbAccountName
  location: location
  tags: tags
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: enablePrivateEndpoint ? 'Disabled' : 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: true
    isVirtualNetworkFilterEnabled: true
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: true
    enableFreeTier: false
    enableAnalyticalStorage: false
    databaseAccountOfferType: 'Standard'
    disableLocalAuth: false
    minimalTlsVersion: 'Tls12'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: []
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
  }
}

// ============================================================================
// SQL Database
// ============================================================================

resource cosmosDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-08-15' = {
  parent: cosmosAccount
  name: cosmosDbDatabaseName
  properties: {
    resource: {
      id: cosmosDbDatabaseName
    }
  }
}

// ============================================================================
// Private DNS Zone
// ============================================================================

resource cosmosDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = if (enablePrivateEndpoint) {
  name: cosmosDbDnsZoneName
  location: 'global'
  tags: tags
}

// ============================================================================
// DNS Zone Virtual Network Link
// ============================================================================

resource cosmosDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (enablePrivateEndpoint && !empty(virtualNetworkId)) {
  parent: cosmosDnsZone
  name: cosmosDbDnsZoneLinkName
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

resource cosmosPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  name: cosmosDbPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'psc-${cosmosDbDatabaseName}'
        properties: {
          privateLinkServiceId: cosmosAccount.id
          groupIds: ['Sql']
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
  parent: cosmosPrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-documents-azure-com'
        properties: {
          privateDnsZoneId: cosmosDnsZone.id
        }
      }
    ]
  }
}

// ============================================================================
// Outputs
// ============================================================================

output cosmosDbAccountId string = cosmosAccount.id
output cosmosDbAccountName string = cosmosAccount.name
output cosmosDbEndpoint string = cosmosAccount.properties.documentEndpoint
output cosmosDbDatabaseId string = cosmosDatabase.id
output privateEndpointId string = enablePrivateEndpoint && !empty(privateEndpointSubnetId) ? cosmosPrivateEndpoint.id : ''
