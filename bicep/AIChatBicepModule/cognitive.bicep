// ============================================================================
// Cognitive Services Module - cognitive.bicep
// Matches Terraform: cognitive.tf, coco-cognitive.tf
// Contains: OpenAI Accounts with Deployments, Form Recognizer, Translator
// ============================================================================

@description('Location for the cognitive services (default)')
param location string

@description('Tags to apply to all resources')
param tags object

@description('OpenAI accounts configuration')
param openaiAccounts object = {}

@description('Name of the Form Recognizer service')
param formRecognizerName string

@description('Location for Form Recognizer')
param formRecognizerLocation string = 'westus2'

@description('Custom subdomain for Form Recognizer')
param formRecognizerSubdomainName string

@description('Name of the Translator service')
param translatorName string

@description('Location for Translator')
param translatorLocation string = 'centralus'

@description('Custom subdomain for Translator')
param translatorSubdomainName string

@description('Enable private endpoint for OpenAI')
param enablePrivateEndpoint bool = true

@description('Subnet ID for private endpoints')
param privateEndpointSubnetId string = ''

@description('Form Recognizer private endpoint name')
param formRecognizerPrivateEndpointName string = ''

@description('Translator private endpoint name')
param translatorPrivateEndpointName string = ''

@description('Cognitive Services DNS zone name')
param cognitiveServicesDnsZoneName string = 'privatelink.cognitiveservices.azure.com'

@description('Virtual network ID for DNS zone link')
param virtualNetworkId string = ''


@description('Cognitive Services DNS zone virtual network link name')
param cognitiveServicesDnsZoneLinkName string = ''

@description('OpenAI DNS zone name')
param openAIDnsZoneName string = 'privatelink.openai.azure.com'

@description('OpenAI DNS zone virtual network link name')
param openAIDnsZoneLinkName string = ''

@description('Embedding quota (used in deployments)')
#disable-next-line no-unused-params
param embeddingQuota string = '175'

// ============================================================================
// Form Recognizer (Document Intelligence)
// ============================================================================

resource formRecognizer 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: formRecognizerName
  location: formRecognizerLocation
  tags: tags
  kind: 'FormRecognizer'
  sku: {
    name: 'S0'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: formRecognizerSubdomainName
    publicNetworkAccess: enablePrivateEndpoint ? 'Disabled' : 'Enabled'
    disableLocalAuth: false
  }
}

// ============================================================================
// Translator
// ============================================================================

resource translator 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: translatorName
  location: translatorLocation
  tags: tags
  kind: 'TextTranslation'
  sku: {
    name: 'S1'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: translatorSubdomainName
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: enablePrivateEndpoint ? 'Disabled' : 'Enabled'
    disableLocalAuth: false
  }
}

// ============================================================================
// Private DNS Zone for Cognitive Services
// ============================================================================

resource cognitiveServicesDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = if (enablePrivateEndpoint) {
  name: cognitiveServicesDnsZoneName
  location: 'global'
  tags: tags
}

// ============================================================================
// Cognitive Services DNS Zone Virtual Network Link
// ============================================================================

resource cognitiveServicesDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (enablePrivateEndpoint && !empty(virtualNetworkId)) {
  parent: cognitiveServicesDnsZone
  name: cognitiveServicesDnsZoneLinkName
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
// Private DNS Zone for OpenAI
// ============================================================================

resource openAIDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = if (enablePrivateEndpoint) {
  name: openAIDnsZoneName
  location: 'global'
  tags: tags
}

// ============================================================================
// OpenAI DNS Zone Virtual Network Link
// ============================================================================

resource openAIDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (enablePrivateEndpoint && !empty(virtualNetworkId)) {
  parent: openAIDnsZone
  name: openAIDnsZoneLinkName
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
// OpenAI Accounts
// Loop through openaiAccounts object to create multiple accounts
// ============================================================================

resource openaiAccount 'Microsoft.CognitiveServices/accounts@2024-10-01' = [for (account, i) in items(openaiAccounts): {
  name: account.value.name
  location: account.value.location
  tags: tags
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  identity: {
    type: 'None'
  }
  properties: {
    customSubDomainName: account.value.?subdomain_name ?? account.value.name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: enablePrivateEndpoint ? 'Disabled' : 'Enabled'
    disableLocalAuth: false
  }
}]

// ============================================================================
// OpenAI Model Deployments
// NOTE: Bicep doesn't support nested loops in variables.
// Model deployments should be done using a separate module or manually.
// For simplicity, we're deploying models using explicit resources per account.
// ============================================================================

// For the first OpenAI account, deploy models
// This is a simplified approach - for multiple accounts with different models,
// consider using a separate module with deployment loops.

@batchSize(1)
resource openaiDeployments 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = [for (model, i) in items(length(items(openaiAccounts)) > 0 ? items(openaiAccounts)[0].value.models : {}): {
  parent: openaiAccount[0]
  name: model.value.deployment_name
  sku: {
    name: model.value.sku_name
    capacity: model.value.capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: model.value.model_name
    }
    raiPolicyName: 'Microsoft.DefaultV2'
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: model.value.capacity
  }
}]

// ============================================================================
// Private Endpoints for OpenAI
// ============================================================================

resource openaiPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = [for (account, i) in items(openaiAccounts): if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  name: account.value.?private_endpoint_name ?? '${account.value.name}-pe'
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: account.value.?private_endpoint_name ?? '${account.value.name}-pe'
        properties: {
          privateLinkServiceId: openaiAccount[i].id
          groupIds: ['account']
          requestMessage: ''
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpointSubnetId
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}]

// ============================================================================
// Private DNS Zone Groups for OpenAI
// ============================================================================

resource openaiPrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = [for (account, i) in items(openaiAccounts): if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  parent: openaiPrivateEndpoint[i]
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink.openai.azure.com'
        properties: {
          privateDnsZoneId: openAIDnsZone.id
        }
      }
    ]
  }
}]

// ============================================================================
// Private Endpoint for Form Recognizer
// ============================================================================

resource formRecognizerPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(formRecognizerPrivateEndpointName)) {
  name: formRecognizerPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: formRecognizerPrivateEndpointName
        properties: {
          privateLinkServiceId: formRecognizer.id
          groupIds: ['account']
          requestMessage: ''
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpointSubnetId
    }
  }
}

// ============================================================================
// Private Endpoint for Translator
// ============================================================================

resource translatorPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(translatorPrivateEndpointName)) {
  name: translatorPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: translatorPrivateEndpointName
        properties: {
          privateLinkServiceId: translator.id
          groupIds: ['account']
          requestMessage: ''
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpointSubnetId
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

output formRecognizerId string = formRecognizer.id
output formRecognizerName string = formRecognizer.name
output formRecognizerEndpoint string = formRecognizer.properties.endpoint
output formRecognizerPrincipalId string = formRecognizer.identity.principalId

output translatorId string = translator.id
output translatorName string = translator.name
output translatorEndpoint string = translator.properties.endpoint
output translatorPrincipalId string = translator.identity.principalId

// Build OpenAI endpoints object - simplified approach
output openAIEndpoints array = [for (account, i) in items(openaiAccounts): {
  key: account.key
  endpoint: openaiAccount[i].properties.endpoint
}]

output openaiAccountIds array = [for (account, i) in items(openaiAccounts): openaiAccount[i].id]
output openaiAccountNames array = [for (account, i) in items(openaiAccounts): openaiAccount[i].name]
output openaiAccountEndpoints array = [for (account, i) in items(openaiAccounts): openaiAccount[i].properties.endpoint]
output openaiAccountPrincipalIds array = [for (account, i) in items(openaiAccounts): openaiAccount[i].identity.principalId]
