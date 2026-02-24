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
param logAnalyticsWorkspaceId string

@description('Log Analytics Customer ID')
param logAnalyticsCustomerId string

@description('Infrastructure subnet ID for Container App Environment')
param containerAppSubnetId string

@description('Container Apps configuration object')
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
#disable-next-line no-unused-params
param containerAppEnvPrivateEndpointName string = ''

@description('Subnet ID for private endpoint')
#disable-next-line no-unused-params
param privateEndpointSubnetId string = ''

@description('Container Apps private DNS zone virtual network link name')
#disable-next-line no-unused-params
param containerAppsDnsZoneLinkName string = ''

@description('Virtual network ID for DNS zone link')
#disable-next-line no-unused-params
param virtualNetworkId string = ''

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
        sharedKey: listKeys(logAnalyticsWorkspaceId, '2023-09-01').primarySharedKey
      }
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
    peerAuthentication: {
      mtls: {
        enabled: false
      }
    }
    peerTrafficConfiguration: {
      encryption: {
        enabled: false
      }
    }
  }
}

// ============================================================================
// Container Apps
// Create a container app for each entry in containerApps object
// ============================================================================

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = [for (app, i) in items(containerApps): {
  name: app.value.name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    environmentId: containerAppEnvironment.id
    configuration: {
      secrets: []
      activeRevisionsMode: app.value.?revision_mode ?? 'Single'
      ingress: {
        external: true
        targetPort: app.value.?target_port ?? 80
        exposedPort: 0
        transport: 'auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
      }
      registries: (deployAcr && (app.value.?use_acr ?? true)) ? [
        {
          server: '${acrName}.azurecr.io'
          identity: 'system-environment'
        }
      ] : []
      maxInactiveRevisions: app.value.?max_inactive_revisions ?? 100
    }
    template: {
      containers: [
        {
          // Image managed by CI/CD - use placeholder for initial deployment
          image: app.value.?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: app.value.name
          resources: {
            cpu: contains(app.value, 'cpu') ? json(app.value.cpu) : json('0.25')
            memory: app.value.?memory ?? '0.5Gi'
          }
          probes: contains(app.value, 'liveness_probe_path') ? [
            {
              type: 'Liveness'
              httpGet: {
                path: app.value.liveness_probe_path
                port: app.value.?liveness_probe_port ?? app.value.?target_port ?? 8001
                scheme: 'HTTP'
              }
              initialDelaySeconds: 1
              periodSeconds: 10
              failureThreshold: 2
              timeoutSeconds: 1
            }
            {
              type: 'Readiness'
              tcpSocket: {
                port: app.value.?target_port ?? 8001
              }
              failureThreshold: 48
              periodSeconds: 5
              successThreshold: 1
              timeoutSeconds: 5
            }
            {
              type: 'Startup'
              tcpSocket: {
                port: app.value.?target_port ?? 8001
              }
              initialDelaySeconds: 1
              periodSeconds: 1
              failureThreshold: 240
              successThreshold: 1
              timeoutSeconds: 3
            }
          ] : []
          env: app.value.?env ?? []
        }
      ]
      scale: {
        minReplicas: app.value.?min_replicas ?? 0
        maxReplicas: app.value.?max_replicas ?? 10
        rules: [
          {
            name: 'http'
             http: {
              metadata: {
                concurrentRequests: '100'
              }
            }
          }
        ]
      }
    }
    workloadProfileName: 'Consumption'
  }
}]

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

output containerAppIds array = [for (app, i) in items(containerApps): containerApp[i].id]
output containerAppNames array = [for (app, i) in items(containerApps): containerApp[i].name]
output containerAppFqdns array = [for (app, i) in items(containerApps): containerApp[i].properties.configuration.ingress != null ? containerApp[i].properties.configuration.ingress.fqdn : '']
output containerAppPrincipalIds array = [for (app, i) in items(containerApps): containerApp[i].identity.principalId]
