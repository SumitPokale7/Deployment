// ============================================================================
// Container Apps Module - containerapp.bicep
// Matches Terraform: containerapp.tf
// Contains: ACR, Container App Environment, Container Apps
// ============================================================================

@description('Location for the container app resources')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Environment name (dev, demo, prod)')
#disable-next-line no-unused-params
param environment string

@description('Name of the Azure Container Registry')
param acrName string

@description('ACR SKU')
@allowed(['Basic', 'Standard', 'Premium'])
param acrSku string = 'Standard'

@description('Deploy ACR (only in dev/prod)')
param deployAcr bool = true

@description('Name of the Container App Environment')
param containerAppEnvName string

@description('Log Analytics Workspace ID')
#disable-next-line no-unused-params
param logAnalyticsWorkspaceId string

@description('Log Analytics Customer ID')
param logAnalyticsCustomerId string

@description('Infrastructure subnet ID for Container App Environment')
param containerAppSubnetId string

@description('Container Apps configuration - NOT USED in this module. Apps are managed by CI/CD pipelines. Kept for interface compatibility with main.bicep.')
#disable-next-line no-unused-params
param containerApps object = {}

@description('Internal load balancer enabled')
param internalLoadBalancerEnabled bool = true

@description('Zone redundancy enabled')
param zoneRedundant bool = false

@description('Workload profile type')
param workloadProfileType string = 'Consumption'

@description('Infrastructure resource group name')
#disable-next-line no-unused-params
param infrastructureResourceGroupName string = ''

@description('Private endpoint name for Container App Environment')
param containerAppEnvPrivateEndpointName string = ''

@description('Network interface name for Container App Environment private endpoint')
param containerAppEnvNetworkInterfaceName string = ''

@description('Name of the Container App Environment network interface IP configuration')
param containerAppEnvNetworkInterfaceIpName string = ''

@description('Private endpoint connection name for Container App Environment')
param containerAppEnvPrivateEndpointConnectionName string = ''

@description('Subnet ID for private endpoint')
param privateEndpointSubnetId string = ''

@description('Container Apps private DNS zone virtual network link name')
#disable-next-line no-unused-params
param containerAppsDnsZoneLinkName string = ''

@description('Virtual network ID for DNS zone link')
#disable-next-line no-unused-params
param virtualNetworkId string = ''

@description('Name of the user assigned managed identity')
param userAssignedIdentityName string

// ============================================================================
// NOTE: Container Apps are NOT managed by Bicep
// They are fully managed by separate CI/CD pipelines that handle:
//   - Docker build & push to ACR
//   - Container App create/update
//   - Environment variables from Azure DevOps library
//   - Health probes, scaling rules, CPU, memory
// The containerApps object is only used for Application Gateway routing config
// ============================================================================

// ============================================================================
// Azure Container Registry
// ============================================================================

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = if (deployAcr) {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    metadataSearch: 'Disabled'
    anonymousPullEnabled: false
  }
}

// ============================================================================
// Container App Environment
// ============================================================================

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: containerAppEnvName
  location: location
  tags: tags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsCustomerId
      }
    }
    peerAuthentication: {
      mtls: { enabled: false }
    }
    peerTrafficConfiguration: {
      encryption: { enabled: false }
    }
    vnetConfiguration: {
      infrastructureSubnetId: containerAppSubnetId
      internal: internalLoadBalancerEnabled
    }
    zoneRedundant: zoneRedundant
    infrastructureResourceGroup: !empty(infrastructureResourceGroupName) ? infrastructureResourceGroupName : null
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: workloadProfileType
      }
    ]
  }
}

// ============================================================================
// Private Endpoints for Cogntive Services (general)
// ============================================================================

resource privateEndpoints 'Microsoft.Network/privateEndpoints@2024-07-01' = {
  name: containerAppEnvPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: containerAppEnvPrivateEndpointConnectionName
        properties: {
          privateLinkServiceId: containerAppEnvironment.id
          groupIds: [
            'managedEnvironments'
          ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpointSubnetId
    }
  }
}

resource networkInterfaces 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: containerAppEnvNetworkInterfaceName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: containerAppEnvNetworkInterfaceIpName
        properties: {
          privateIPAddress: '10.0.3.13'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: privateEndpointSubnetId
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

// ============================================================================
// Managed Identity
// ============================================================================
resource userAssignedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: userAssignedIdentityName
  location: 'eastus'
  tags: union(tags, {
    AtlasPurpose: 'Atlas-MSI-Generic'
    TemplateVersion: 'Non-Atlas deployment using Atlas artifacts-2.1.70'
    createdOn: '2024-11-05'
  })
  properties: {
    isolationScope: 'None'
  }
}

// ============================================================================
// Container Apps - SKIPPED (Managed by CI/CD Pipelines)
// Container Apps are NOT deployed by Bicep.
// They are created and managed by separate CI/CD pipelines.
// The containerApps parameter object is retained for:
//   - Application Gateway backend pool configuration
//   - Routing rules and path patterns
// ============================================================================

// ============================================================================
// Container App Jobs - NOT MANAGED BY BICEP
// Jobs (like index-migration) are managed by CI/CD pipelines
// ============================================================================

// ============================================================================
// Outputs
// ============================================================================

output acrId string = deployAcr ? acr!.id : ''
output acrName string = deployAcr ? acr!.name : ''
output acrLoginServer string = deployAcr ? acr!.properties.loginServer : ''
output acrPrincipalId string = deployAcr ? acr!.identity.principalId : ''

output containerAppEnvId string = containerAppEnvironment.id
output containerAppEnvName string = containerAppEnvironment.name
output containerAppEnvDefaultDomain string = containerAppEnvironment.properties.defaultDomain
output containerAppEnvStaticIp string = containerAppEnvironment.properties.staticIp

// Container App outputs - NOT AVAILABLE (apps managed by CI/CD)
// Use Azure CLI or Azure Portal to get container app details
