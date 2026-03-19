// ============================================================================
// Key Vault Module - vault.bicep
// Matches Terraform: vault.tf
// Contains: Key Vault
// ============================================================================

@description('Location for the Key Vault')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Environment name - used for conditional deployment')
@allowed(['dev', 'demo', 'prod'])
param environment string

@description('Name of the Key Vault')
param keyVaultName string

@description('Tenant ID for Key Vault')
param tenantId string = subscription().tenantId

@description('Enable RBAC authorization instead of access policies')
param enableRbacAuthorization bool = true

@description('Enable soft delete')
param enableSoftDelete bool = true

@description('Public network access setting')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Name of the cognitive services Key Vault')
param cognitiveKeyVaultName string

// ============================================================================
// Key Vault
// ============================================================================

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    accessPolicies: []
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: enableSoftDelete
    enableRbacAuthorization: enableRbacAuthorization
    publicNetworkAccess: publicNetworkAccess
  }
}

resource vaults_kv_d01_ai_cognitive_01 'Microsoft.KeyVault/vaults@2024-12-01-preview' = if (environment == 'dev') {
  name: cognitiveKeyVaultName
  location: 'eastus2'
  tags: union(tags, {
    AtlasPurpose: 'Atlas-KeyVault-Generic'
    TemplateVersion: 'Non-Atlas deployment using Atlas artifacts-2.1.70'
    createdOn: '2024-11-05'
  })
  properties: {
    sku: {
      family: 'A'
      name: 'premium'
    }
    tenantId: tenantId
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '208.91.239.10/32'
        }
        {
          value: '208.91.239.11/32'
        }
        {
          value: '208.91.239.30/32'
        }
        {
          value: '208.91.237.161/32'
        }
        {
          value: '208.91.237.162/32'
        }
        {
          value: '208.91.237.190/32'
        }
        {
          value: '8.36.116.204/32'
        }
        {
          value: '40.70.130.19/32'
        }
        {
          value: '52.179.197.140/32'
        }
        {
          value: '20.80.45.128/28'
        }
        {
          value: '20.94.99.16/28'
        }
      ]
    }
      accessPolicies: [
      {
        tenantId: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
        objectId: '394cd05b-9c01-4a9b-abfe-e9ba1d1533bf'
        permissions: {
          keys: [
            'Decrypt'
            'Encrypt'
            'UnwrapKey'
            'WrapKey'
            'Verify'
            'Sign'
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Backup'
            'Restore'
            'Recover'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Backup'
            'Restore'
            'Recover'
          ]
          certificates: [
            'Get'
            'List'
            'Delete'
            'Create'
            'Import'
            'Update'
            'ManageContacts'
            'GetIssuers'
            'ListIssuers'
            'SetIssuers'
            'DeleteIssuers'
            'ManageIssuers'
            'Recover'
            'Backup'
            'Restore'
          ]
          storage: [
            'get'
            'list'
            'delete'
            'set'
            'update'
            'regeneratekey'
            'getsas'
            'listsas'
            'deletesas'
            'setsas'
          ]
        }
      }
      {
        tenantId: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
        objectId: '4087210c-fdf5-4514-bcdc-17c1b7507890'
        permissions: {
          keys: [
            'Create'
            'Update'
            'Delete'
            'List'
          ]
          secrets: [
            'Set'
            'Delete'
            'List'
          ]
          certificates: [
            'Create'
            'Update'
            'ManageContacts'
            'ManageIssuers'
            'SetIssuers'
            'Delete'
            'List'
          ]
          storage: []
        }
      }
      {
        tenantId: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
        objectId: '2060ad6a-9d17-4f83-8861-b8e3ef97b9be'
        permissions: {
          keys: [
            'Get'
            'List'
            'Update'
            'Create'
            'Delete'
            'Sign'
            'Verify'
            'Decrypt'
            'Encrypt'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
          ]
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Delete'
            'Import'
          ]
          storage: []
        }
      }
      {
        tenantId: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
        objectId: '7a0998de-04b8-4948-9e22-9d53db07472e'
        permissions: {
          keys: [
            'Get'
            'List'
            'Update'
            'Create'
            'Delete'
            'Sign'
            'Verify'
            'Decrypt'
            'Encrypt'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
          ]
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Delete'
            'Import'
          ]
          storage: []
        }
      }
      {
        tenantId: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
        objectId: 'c5a1f449-bedd-452d-b4ea-ecc0495827a3'
        permissions: {
          keys: [
            'Get'
            'List'
            'Update'
            'Create'
            'Delete'
            'Sign'
            'Verify'
            'Decrypt'
            'Encrypt'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
          ]
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Delete'
            'Import'
          ]
          storage: []
        }
      }
      {
        tenantId: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
        objectId: 'a4daebb6-0119-455f-a92a-1013c76edefc'
        permissions: {
          certificates: []
          keys: []
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: false
    publicNetworkAccess: 'Enabled'
  }
}


// ============================================================================
// Outputs
// ============================================================================

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
