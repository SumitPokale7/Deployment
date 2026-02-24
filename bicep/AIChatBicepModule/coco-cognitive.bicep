@description('Environment name - used for conditional deployment')
@allowed(['dev', 'demo', 'prod'])
param environment string

// Cognitive Account
resource cocoOpenAi 'Microsoft.CognitiveServices/accounts@2023-05-01' = if (environment == 'prod') {
  name: 'coco-cognitive-account-eus'
  location: 'eastus2'
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: 'coco-cognitive-account-eus'
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: [
        { value: '208.91.239.10' }
        { value: '208.91.239.11' }
        { value: '208.91.237.161' }
        { value: '208.91.237.162' }
        { value: '208.91.239.30' }
        { value: '208.91.237.190' }
        { value: '208.91.236.126' }
        { value: '208.91.238.126' }
        { value: '198.245.150.222' }
        { value: '208.91.239.1' }
        { value: '20.94.99.16/28' }
        { value: '20.80.45.128/28' }
        { value: '172.177.156.178' }
      ]
    }
  }
}

// GPT-4o Deployment
resource gpt4o 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = if (environment == 'prod') {
  name: 'gpt-4o'
  parent: cocoOpenAi
  sku: {
    name: 'Standard'
    capacity: 250
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      // NOTE: Terraform ignored model.version
      // If Azure auto-sets version, Bicep may show drift
    }
  }
}

// Embedding Deployment
resource embedding 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = if (environment == 'prod') {
  name: 'text-embedding-ada-002'
  parent: cocoOpenAi
  sku: {
    name: 'Standard'
    capacity: 150
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-ada-002'
      version: '2'
    }
  }
}
