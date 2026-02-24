// ============================================================================
// Storage Module - storage.bicep
// Matches Terraform: storage.tf
// Contains: Storage Account, Blob Container
// ============================================================================

@description('Location for the storage resources')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Name of the storage account')
param storageAccountName string

@description('Name of the blob container')
param blobContainerName string

@description('CORS allowed origins')
param corsAllowedOrigins array = []

// ============================================================================
// Storage Account
// ============================================================================

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'None'
  }
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    isNfsV3Enabled: false
    isLocalUserEnabled: true
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    isHnsEnabled: false
    networkAcls: {
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

// ============================================================================
// Blob Service with CORS
// ============================================================================

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: length(corsAllowedOrigins) > 0 ? [
        {
          allowedHeaders: ['*']
          allowedMethods: ['GET']
          allowedOrigins: corsAllowedOrigins
          exposedHeaders: ['*']
          maxAgeInSeconds: 3600
        }
      ] : []
    }
    deleteRetentionPolicy: {
      enabled: false
    }
  }
}

// ============================================================================
// Blob Container
// ============================================================================

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: blobService
  name: blobContainerName
  properties: {
    publicAccess: 'None'
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
  }
}

// ============================================================================
// Outputs
// ============================================================================

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output primaryBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
output blobContainerId string = blobContainer.id
