// ============================================================================
// Networking Module - networking.bicep
// Matches Terraform: application.tf (networking portions)
// Contains: VNet, Subnets, NSGs, Public IP
// ============================================================================

@description('Location for the networking resources')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Name of the Virtual Network')
param vnetName string

@description('Address space for the VNet')
param vnetAddressSpace array = ['10.0.0.0/16']

// ============================================================================
// Subnet Parameters
// ============================================================================

@description('Name of the Application Gateway WAF subnet')
param agwafSubnetName string = 'agwaf_subnet'

@description('Address prefix for the Application Gateway WAF subnet')
param agwafSubnetAddressPrefix string = '10.0.6.0/26'

@description('Name of the private endpoint subnet')
param privateEndpointSubnetName string

@description('Address prefix for the private endpoint subnet')
param privateEndpointSubnetAddressPrefix string = '10.0.3.0/24'

@description('Name of the Container Apps subnet')
param containerAppSubnetName string

@description('Address prefix for the Container Apps subnet')
param containerAppSubnetAddressPrefix string = '10.0.8.0/23'

// ============================================================================
// NSG Parameters
// ============================================================================

@description('Name of the Application Gateway WAF NSG')
param agwafNsgName string

@description('Name of the Private Endpoint NSG')
param privateEndpointNsgName string

// ============================================================================
// Public IP Parameters
// ============================================================================

@description('Name of the Public IP for Application Gateway')
param publicIpName string

// ============================================================================
// Network Security Groups
// ============================================================================

resource agwafNsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: agwafNsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AgWafv2TCPRequired'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '65200-65535'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'internet443inbound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAnyAnyInbound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource privateEndpointNsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: privateEndpointNsgName
  location: location
  tags: tags
  properties: {
    securityRules: []
  }
}

// ============================================================================
// Virtual Network
// ============================================================================

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }
  }
}

// ============================================================================
// Subnets
// ============================================================================

resource agwafSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: vnet
  name: agwafSubnetName
  properties: {
    addressPrefix: agwafSubnetAddressPrefix
    networkSecurityGroup: {
      id: agwafNsg.id
    }
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: true
  }
}

resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: vnet
  name: privateEndpointSubnetName
  properties: {
    addressPrefix: privateEndpointSubnetAddressPrefix
    networkSecurityGroup: {
      id: privateEndpointNsg.id
    }
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    agwafSubnet
  ]
}

resource containerAppSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: vnet
  name: containerAppSubnetName
  properties: {
    addressPrefix: containerAppSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: [
      {
        name: 'delegation'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
  }
  dependsOn: [
    privateEndpointSubnet
  ]
}

// ============================================================================
// Public IP Address
// ============================================================================

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIpName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

output vnetId string = vnet.id
output vnetName string = vnet.name
output agwafSubnetId string = agwafSubnet.id
output privateEndpointSubnetId string = privateEndpointSubnet.id
output containerAppSubnetId string = containerAppSubnet.id
output agwafNsgId string = agwafNsg.id
output privateEndpointNsgId string = privateEndpointNsg.id
output publicIpId string = publicIp.id
output publicIpAddress string = publicIp.properties.ipAddress
