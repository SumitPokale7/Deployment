// ============================================================================
// Application Gateway WAF Module - agwaf.bicep
// Matches Terraform: agwaf.tf
// Contains: Application Gateway with WAF, WAF Policy, Path-Based Routing
// ============================================================================

@description('Location for the Application Gateway resources')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Name of the Application Gateway')
param applicationGatewayName string

@description('Name of the WAF Policy')
param wafPolicyName string = ''

@description('Public IP address ID')
param publicIpId string

@description('Subnet ID for Application Gateway')
param agwafSubnetId string

@description('Environment name - used for conditional deployment')
@allowed(['dev', 'demo', 'prod'])
param environment string

@description('Container Apps configuration with AGW settings')
param containerApps object = {}

@description('Container App Environment default domain')
param containerAppEnvironmentDomain string = ''

@description('Container App Environment static IP')
#disable-next-line no-unused-params
param containerAppEnvironmentStaticIp string = ''

@description('Black listed countries for geo-blocking')
param blackListedCountries array = []

@description('APIM IP address')
param apimIp string = ''

@description('VPN IP addresses for whitelist')
param vpnIpAddresses array = [
  '208.91.239.10/32'
  '208.91.239.11/32'
  '208.91.237.161/32'
  '208.91.237.162/32'
  '208.91.239.30/32'
  '208.91.237.190/32'
  '208.91.236.126/32'
  '208.91.238.126/32'
  '198.245.150.222/32'
  '208.91.239.1/32'
  '20.94.99.16/28'
  '20.80.45.128/28'
]

@description('Veracode IP address')
param veracodeIp string = '34.195.146.191'

@description('Enable VPN IP whitelist')
param enableVpnWhitelist bool = true

@description('Application Gateway SKU name')
@allowed(['Standard_v2', 'WAF_v2'])
param appGatewaySkuName string = 'WAF_v2'

@description('Application Gateway tier')
@allowed(['Standard_v2', 'WAF_v2'])
param appGatewayTier string = 'WAF_v2'

@description('Application Gateway capacity (instance count)')
param appGatewayCapacity int = 2

@description('WAF mode - Detection or Prevention')
@allowed(['Detection', 'Prevention'])
param wafMode string = 'Prevention'

@description('WAF rule set type')
param wafRuleSetType string = 'OWASP'

@description('WAF rule set version')
param wafRuleSetVersion string = '3.2'

// Investment-specific parameters (not deployed in dev)
@description('Backend address pool FQDN for investment frontend')
param backendAddressPoolFrontendInv string = ''

@description('Backend address pool FQDN for investment backend')
param backendAddressPoolBackendInv string = ''

// SSL Certificate parameters
@description('SSL certificate data (base64 encoded PFX)')
@secure()
param sslCertificateData string = ''

@description('SSL certificate password')
@secure()
param sslCertificatePassword string = ''

@description('Use Key Vault for SSL certificate')
#disable-next-line no-unused-params
param useKeyVaultCertificate bool = false

@description('Key Vault secret ID for SSL certificate')
@secure()
param keyVaultCertificateSecretId string = ''

// Storage names for CSP header
@description('Primary storage account name')
param storageName string = ''

@description('Investment storage account name (demo/prod only)')
param investmentStorageName string = ''

@description('Static error page URL for 403')
param staticErrorPageUrl403 string = ''

// ============================================================================
// Derived Variables
// ============================================================================

var derivedWafPolicyName = !empty(wafPolicyName) ? wafPolicyName : 'wafpolicy-owasp-geoblock'

// Filter container apps that have AGW integration enabled (unsorted)
var agwEnabledAppsUnsorted = filter(items(containerApps), app => app.value.?agw_enabled ?? false)

// Sort AGW-enabled apps by agw_index to preserve the existing Azure resource order.
// This prevents drift caused by Bicep's items() alphabetical sort differing from
// the order in which resources were originally created in Azure.
// Each app in containerApps that has agw_enabled:true MUST also define agw_index (0-based).
var agwEnabledApps = [for i in range(0, length(agwEnabledAppsUnsorted)): filter(agwEnabledAppsUnsorted, app => (app.value.?agw_index ?? 999) == i)[0]]

// Separate sorted arrays for probes and pathRules — Azure stored these in different orders at deploy time
var agwEnabledAppsForProbes = [for i in range(0, length(agwEnabledAppsUnsorted)): filter(agwEnabledAppsUnsorted, app => (app.value.?agw_probe_index ?? 999) == i)[0]]
var agwEnabledAppsForPathRules = [for i in range(0, length(agwEnabledAppsUnsorted)): filter(agwEnabledAppsUnsorted, app => (app.value.?agw_path_index ?? 999) == i)[0]]

// Filter container apps that have URL rewrite enabled
var containerAppsWithRewrite = filter(agwEnabledApps, app => app.value.?agw_rewrite_enabled ?? false)

// Determine if investment should be deployed (not in dev)
var deployInvestment = environment != 'dev' && !empty(backendAddressPoolFrontendInv) && !empty(backendAddressPoolBackendInv)

// CSP header value based on environment
var cspHeaderValue = environment == 'dev' 
  ? 'default-src \'self\'; script-src \'self\' \'sha256-eV3QMumkWxytVHa/LDvu+mnW+PcSAEI4SfFu0iIlbDc=\' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src \'self\' data: https://fastapi.tiangolo.com https://dev.azure.com https://*.gstatic.com https://www.google.com https://${storageName}.blob.core.windows.net; style-src \'self\' \'unsafe-inline\' https://fonts.googleapis.com https://cdn.jsdelivr.net; font-src \'self\' https://fonts.gstatic.com; object-src \'none\'; frame-ancestors \'none\'; base-uri \'self\'; form-action \'self\';connect-src \'self\' https://federationdemo.trustage.com https://${storageName}.blob.core.windows.net blob:; worker-src \'self\' blob:;'
  : environment == 'demo'
    ? 'default-src \'self\'; script-src \'self\' \'sha256-TsjSCX4yUK50HmnZXTe4FVW3iPTz1cIqzuXQu1ozcFU=\' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src \'self\' data: https://fastapi.tiangolo.com https://dev.azure.com https://${investmentStorageName}.blob.core.windows.net https://${storageName}.blob.core.windows.net; style-src \'self\' \'unsafe-inline\' https://fonts.googleapis.com https://cdn.jsdelivr.net; font-src \'self\' https://fonts.gstatic.com; object-src \'none\'; frame-ancestors \'none\'; base-uri \'self\'; form-action \'self\';connect-src \'self\' https://federationdemo.trustage.com https://${investmentStorageName}.blob.core.windows.net https://${storageName}.blob.core.windows.net blob:; worker-src \'self\' blob:;'
    : 'default-src \'self\'; script-src \'self\' \'sha256-TsjSCX4yUK50HmnZXTe4FVW3iPTz1cIqzuXQu1ozcFU=\' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src \'self\' data: https://fastapi.tiangolo.com https://dev.azure.com https://${investmentStorageName}.blob.core.windows.net https://${storageName}.blob.core.windows.net; style-src \'self\' \'unsafe-inline\' https://fonts.googleapis.com https://cdn.jsdelivr.net; font-src \'self\' https://fonts.gstatic.com; object-src \'none\'; frame-ancestors \'none\'; base-uri \'self\'; form-action \'self\';connect-src \'self\' https://federation.trustage.com https://${investmentStorageName}.blob.core.windows.net https://${storageName}.blob.core.windows.net blob:; worker-src \'self\' blob:;'

// VPN IPs including APIM for block rule
var vpnIpsWithApim = !empty(apimIp) ? concat(vpnIpAddresses, [veracodeIp, apimIp]) : concat(vpnIpAddresses, [veracodeIp])

// AI-related request parameter names that need WAF SQLI/XSS exclusions
var aiParamNames = [
  'message'
  'query'
  'prompt'
  'content'
  'input'
  'text'
  'data'
  'payload'
  'body'
  'request'
  'chat'
  'conversation'
  'response'
  'answer'
  'question'
  'instruction'
  'system'
  'user'
  'assistant'
  'context'
  'history'
  'thread'
  'session'
  'completion'
  'generate'
]

// SQLI and XSS exclusion rule sets applied to AI params
var sqliAndXssExclusionRuleSets = [
  {
    ruleSetType: wafRuleSetType
    ruleSetVersion: wafRuleSetVersion
    ruleGroups: [
      {
        ruleGroupName: 'REQUEST-942-APPLICATION-ATTACK-SQLI'
        rules: [
          { ruleId: '942100' }
          { ruleId: '942110' }
          { ruleId: '942120' }
          { ruleId: '942130' }
          { ruleId: '942140' }
          { ruleId: '942150' }
          { ruleId: '942160' }
          { ruleId: '942170' }
          { ruleId: '942180' }
          { ruleId: '942190' }
          { ruleId: '942200' }
          { ruleId: '942210' }
          { ruleId: '942220' }
          { ruleId: '942230' }
          { ruleId: '942240' }
          { ruleId: '942250' }
          { ruleId: '942260' }
          { ruleId: '942270' }
          { ruleId: '942280' }
          { ruleId: '942290' }
          { ruleId: '942300' }
          { ruleId: '942310' }
          { ruleId: '942320' }
          { ruleId: '942330' }
          { ruleId: '942340' }
          { ruleId: '942350' }
          { ruleId: '942360' }
          { ruleId: '942370' }
          { ruleId: '942380' }
          { ruleId: '942390' }
          { ruleId: '942400' }
          { ruleId: '942410' }
          { ruleId: '942420' }
          { ruleId: '942430' }
          { ruleId: '942440' }
          { ruleId: '942450' }
          { ruleId: '942460' }
          { ruleId: '942470' }
          { ruleId: '942480' }
          { ruleId: '942490' }
          { ruleId: '942500' }
        ]
      }
      {
        ruleGroupName: 'REQUEST-941-APPLICATION-ATTACK-XSS'
        rules: [
          { ruleId: '941100' }
          { ruleId: '941110' }
          { ruleId: '941120' }
          { ruleId: '941130' }
          { ruleId: '941140' }
          { ruleId: '941150' }
          { ruleId: '941160' }
          { ruleId: '941170' }
          { ruleId: '941180' }
          { ruleId: '941190' }
          { ruleId: '941200' }
          { ruleId: '941210' }
          { ruleId: '941220' }
          { ruleId: '941230' }
          { ruleId: '941240' }
          { ruleId: '941250' }
          { ruleId: '941260' }
          { ruleId: '941270' }
          { ruleId: '941280' }
          { ruleId: '941290' }
          { ruleId: '941300' }
        ]
      }
      {
        ruleGroupName: 'REQUEST-931-APPLICATION-ATTACK-RFI'
        rules: [
          { ruleId: '931100' }
          { ruleId: '931110' }
          { ruleId: '931120' }
          { ruleId: '931130' }
        ]
      }
    ]
  }
]

// WAF exclusions for AI param names (both RequestArgNames and RequestArgValues)
var aiParamNamesExclusions = [for name in aiParamNames: {
  matchVariable: 'RequestArgNames'
  selectorMatchOperator: 'Contains'
  selector: name
  exclusionManagedRuleSets: sqliAndXssExclusionRuleSets
}]

var aiParamValuesExclusions = [for name in aiParamNames: {
  matchVariable: 'RequestArgValues'
  selectorMatchOperator: 'Contains'
  selector: name
  exclusionManagedRuleSets: sqliAndXssExclusionRuleSets
}]

// Pre-compute arrays for use in Application Gateway properties
// (Bicep doesn't support for-expressions inside concat())

// Container Apps backend pools
var containerAppBackendPools = [for app in agwEnabledApps: {
  name: 'address-pool-${app.key}-containerapp'
  properties: {
    backendAddresses: !empty(containerAppEnvironmentDomain) ? [
      {
        fqdn: '${app.value.name}.${containerAppEnvironmentDomain}'
      }
    ] : []
  }
}]

// Investment backend pools
var investmentBackendPools = deployInvestment ? [
  {
    name: 'address-pool-frontend-inv'
    properties: {
      backendAddresses: [
        {
          fqdn: backendAddressPoolFrontendInv
        }
      ]
    }
  }
  {
    name: 'address-pool-backend-inv'
    properties: {
      backendAddresses: [
        {
          fqdn: backendAddressPoolBackendInv
        }
      ]
    }
  }
] : []

// Container Apps HTTP settings
var containerAppHttpSettings = [for app in agwEnabledApps: {
  name: 'http-settings-${app.key}-containerapp'
  properties: {
    port: 443
    protocol: 'Https'
    cookieBasedAffinity: 'Disabled'
    pickHostNameFromBackendAddress: true
    requestTimeout: app.value.?agw_request_timeout ?? 90
    probe: {
      id: resourceId('Microsoft.Network/applicationGateways/probes', applicationGatewayName, '${app.key}-containerapp-health-probe')
    }
  }
}]

// Investment HTTP settings
var investmentHttpSettings = deployInvestment ? [
  {
    name: 'http-settings-backend-inv'
    properties: {
      port: 443
      protocol: 'Https'
      cookieBasedAffinity: 'Disabled'
      pickHostNameFromBackendAddress: true
      requestTimeout: 90
      probe: {
        id: resourceId('Microsoft.Network/applicationGateways/probes', applicationGatewayName, 'backend-health-probe-inv')
      }
    }
  }
  {
    name: 'http-settings-frontend-inv'
    properties: {
      port: 443
      protocol: 'Https'
      cookieBasedAffinity: 'Disabled'
      pickHostNameFromBackendAddress: true
      requestTimeout: 90
    }
  }
] : []

// Container Apps probes
var containerAppProbes = [for app in agwEnabledAppsForProbes: {
  name: '${app.key}-containerapp-health-probe'
  properties: {
    protocol: 'Https'
    path: app.value.?liveness_probe_path ?? '/health'
    interval: app.value.?agw_probe_interval ?? 30
    timeout: app.value.?agw_probe_timeout ?? 30
    unhealthyThreshold: app.value.?agw_probe_unhealthy_threshold ?? 3
    pickHostNameFromBackendHttpSettings: true
    minServers: 0
    match: {
      statusCodes: ['200-399']
    }
  }
}]

// Investment probes
var investmentProbes = deployInvestment ? [
  {
    name: 'backend-health-probe-inv'
    properties: {
      protocol: 'Https'
      path: '/investmentapi/health'
      interval: 30
      timeout: 30
      unhealthyThreshold: 3
      pickHostNameFromBackendHttpSettings: true
      minServers: 0
      match: {
        statusCodes: ['200-399']
      }
    }
  }
] : []

// Container Apps path rules
var containerAppPathRules = [for app in agwEnabledAppsForPathRules: {
  name: 'containerapp-${app.key}-rule'
  properties: {
    paths: app.value.?agw_path_patterns ?? ['/${app.key}/*']
    backendAddressPool: {
      id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'address-pool-${app.key}-containerapp')
    }
    backendHttpSettings: {
      id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'http-settings-${app.key}-containerapp')
    }
    rewriteRuleSet: {
      id: resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', applicationGatewayName, 'uri-rewrite')
    }
  }
}]

// Investment path rules
var investmentPathRules = deployInvestment ? [
  {
    name: 'frontend-rule-inv'
    properties: {
      paths: ['/investment/*']
      backendAddressPool: {
        id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'address-pool-frontend-inv')
      }
      backendHttpSettings: {
        id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'http-settings-frontend-inv')
      }
      rewriteRuleSet: {
        id: resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', applicationGatewayName, 'uri-rewrite')
      }
    }
  }
  {
    name: 'frontend-rule-inv-1'
    properties: {
      paths: ['/investment']
      backendAddressPool: {
        id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'address-pool-frontend-inv')
      }
      backendHttpSettings: {
        id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'http-settings-frontend-inv')
      }
      rewriteRuleSet: {
        id: resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', applicationGatewayName, 'uri-rewrite')
      }
    }
  }
  {
    name: 'backend-rule-inv'
    properties: {
      paths: ['/investmentapi/*']
      backendAddressPool: {
        id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'address-pool-backend-inv')
      }
      backendHttpSettings: {
        id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'http-settings-backend-inv')
      }
      rewriteRuleSet: {
        id: resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', applicationGatewayName, 'uri-rewrite')
      }
    }
  }
] : []

// Investment rewrite rules
var investmentRewriteRules = deployInvestment ? [
  {
    ruleSequence: 100
    conditions: [
      {
        variable: 'var_uri_path'
        pattern: '/investment/(.*)'
        ignoreCase: true
        negate: false
      }
    ]
    name: 'rewrite-investment-path'
    actionSet: {
      requestHeaderConfigurations: []
      responseHeaderConfigurations: []
      urlConfiguration: {
        modifiedPath: '/{var_uri_path_1}'
        reroute: false
      }
    }
  }
] : []

// Security header rewrite rules
var securityHeaderRewriteRules = [
  {
    ruleSequence: 10
    conditions: []
    name: 'Content-Security-Policy'
    actionSet: {
      requestHeaderConfigurations: []
      responseHeaderConfigurations: [
        {
          headerName: 'Content-Security-Policy'
          headerValue: cspHeaderValue
        }
      ]
    }
  }
  {
    ruleSequence: 13
    conditions: []
    name: 'Strict-Transport-Security'
    actionSet: {
      requestHeaderConfigurations: []
      responseHeaderConfigurations: [
        {
          headerName: 'Strict-Transport-Security'
          headerValue: 'max-age=31536000; includeSubDomains; preload'
        }
      ]
    }
  }
]

// Container Apps rewrite rules
var containerAppRewriteRules = [for app in containerAppsWithRewrite: {
  ruleSequence: app.value.?agw_rewrite_sequence ?? 50
  conditions: [
    {
      variable: 'var_uri_path'
      pattern: app.value.agw_rewrite_pattern
      ignoreCase: true
      negate: false
    }
  ]
  name: 'rewrite-${app.key}-path'
  actionSet: {
    requestHeaderConfigurations: []
    responseHeaderConfigurations: []
    urlConfiguration: {
      modifiedPath: app.value.agw_rewrite_path
      reroute: false
    }
  }
}]

// ============================================================================
// WAF Policy
// ============================================================================

resource wafPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2024-05-01' = {
  name: derivedWafPolicyName
  location: location
  tags: tags
  properties: {
    customRules: concat(
      // Geo-blocking rule
      length(blackListedCountries) > 0 ? [
        {
          name: 'blockBlacklistedCountries'
          priority: 1
          ruleType: 'MatchRule'
          action: 'Block'
          state: 'Enabled'
          matchConditions: [
            {
              matchVariables: [
                {
                  variableName: 'RemoteAddr'
                }
              ]
              operator: 'GeoMatch'
              negationConditon: false
              matchValues: blackListedCountries
              transforms: []
            }
          ]
        }
      ] : [],
      // VPN whitelist rules (enabled for all environments)
      enableVpnWhitelist ? [
        {
          name: 'AllowVPNIPs'
          priority: 2
          ruleType: 'MatchRule'
          action: 'Allow'
          state: 'Enabled'
          matchConditions: [
            {
              matchVariables: [
                {
                  variableName: 'RemoteAddr'
                }
              ]
              operator: 'IPMatch'
              negationConditon: false
              matchValues: vpnIpAddresses
              transforms: []
            }
          ]
        }
        {
          name: 'BlockNonVPNIPs'
          priority: 5
          ruleType: 'MatchRule'
          action: 'Block'
          state: 'Enabled'
          matchConditions: [
            {
              matchVariables: [
                {
                  variableName: 'RemoteAddr'
                }
              ]
              operator: 'IPMatch'
              negationConditon: true // Block IPs NOT in VPN/Veracode ranges
              matchValues: vpnIpsWithApim
              transforms: []
            }
          ]
        }
        {
          name: 'Veracode'
          priority: 3
          ruleType: 'MatchRule'
          action: 'Allow'
          state: 'Enabled'
          matchConditions: [
            {
              matchVariables: [
                {
                  variableName: 'RemoteAddr'
                }
              ]
              operator: 'IPMatch'
              negationConditon: false
              matchValues: [veracodeIp]
              transforms: []
            }
          ]
        }
      ] : []
    )
    policySettings: {
      requestBodyCheck: true
      maxRequestBodySizeInKb: 512
      fileUploadLimitInMb: 100
      state: 'Enabled'
      mode: wafMode
      requestBodyInspectLimitInKB: 128
      fileUploadEnforcement: true
      requestBodyEnforcement: true
      jsChallengeCookieExpirationInMins: 30
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: wafRuleSetType
          ruleSetVersion: wafRuleSetVersion
          ruleGroupOverrides: [
            {
              ruleGroupName: 'REQUEST-942-APPLICATION-ATTACK-SQLI'
              rules: [
                { ruleId: '942200', state: 'Enabled', action: 'Log' }
                { ruleId: '942260', state: 'Enabled', action: 'Log' }
                { ruleId: '942330', state: 'Enabled', action: 'Log' }
                { ruleId: '942340', state: 'Enabled', action: 'Log' }
                { ruleId: '942370', state: 'Enabled', action: 'Log' }
                { ruleId: '942380', state: 'Enabled', action: 'Log' }
                { ruleId: '942440', state: 'Enabled', action: 'Log' }
                { ruleId: '942450', state: 'Enabled', action: 'Log' }
                { ruleId: '942470', state: 'Enabled', action: 'Log' }
              ]
            }
          ]
        }
      ]
      exclusions: concat(
        // Exclusion for search_filters (dev/demo only)
        environment != 'prod' ? [
          {
            matchVariable: 'RequestArgNames'
            selectorMatchOperator: 'Contains'
            selector: 'search_filters'
            exclusionManagedRuleSets: [
              {
                ruleSetType: wafRuleSetType
                ruleSetVersion: wafRuleSetVersion
                ruleGroups: [
                  {
                    ruleGroupName: 'REQUEST-931-APPLICATION-ATTACK-RFI'
                    rules: [
                      { ruleId: '931100' }
                      { ruleId: '931110' }
                      { ruleId: '931120' }
                      { ruleId: '931130' }
                    ]
                  }
                ]
              }
            ]
          }
          {
            matchVariable: 'RequestArgNames'
            selectorMatchOperator: 'Contains'
            selector: 'urls_scrape'
            exclusionManagedRuleSets: [
              {
                ruleSetType: wafRuleSetType
                ruleSetVersion: wafRuleSetVersion
                ruleGroups: [
                  {
                    ruleGroupName: 'REQUEST-931-APPLICATION-ATTACK-RFI'
                    rules: [
                      { ruleId: '931100' }
                      { ruleId: '931110' }
                      { ruleId: '931120' }
                      { ruleId: '931130' }
                    ]
                  }
                ]
              }
            ]
          }
        ] : [],
        // _bti cookie exclusion (all environments)
        [
          {
            matchVariable: 'RequestCookieNames'
            selectorMatchOperator: 'Equals'
            selector: '_bti'
            exclusionManagedRuleSets: [
              {
                ruleSetType: wafRuleSetType
                ruleSetVersion: wafRuleSetVersion
                ruleGroups: [
                  {
                    ruleGroupName: 'REQUEST-942-APPLICATION-ATTACK-SQLI'
                    rules: [
                      { ruleId: '942200' }
                      { ruleId: '942260' }
                      { ruleId: '942340' }
                      { ruleId: '942370' }
                    ]
                  }
                ]
              }
            ]
          }
        ],
        aiParamNamesExclusions,
        aiParamValuesExclusions
      )
    }
  }
}

// ============================================================================
// Application Gateway
// ============================================================================

resource appGateway 'Microsoft.Network/applicationGateways@2024-05-01' = {
  name: applicationGatewayName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'Generation_2'
      name: appGatewaySkuName
      tier: appGatewayTier
      capacity: appGatewayCapacity
    }
    gatewayIPConfigurations: [
      {
        name: 'agwaf-gateway-ip-config'
        properties: {
          subnet: {
            id: agwafSubnetId
          }
        }
      }
    ]
    sslCertificates: !empty(keyVaultCertificateSecretId) ? [
      {
        name: 'front-end-cert'
        properties: {
          keyVaultSecretId: keyVaultCertificateSecretId
        }
      }
    ] : !empty(sslCertificateData) ? [
      {
        name: 'front-end-cert'
        properties: {
          data: sslCertificateData
          password: sslCertificatePassword
        }
      }
    ] : []
    sslPolicy: {
      policyType: 'Predefined'
      policyName: 'AppGwSslPolicy20220101S'
    }
    trustedRootCertificates: []
    trustedClientCertificates: []
    sslProfiles: []
    frontendIPConfigurations: [
      {
        name: 'agwaf-frontend-ip-config'
        properties: {
          publicIPAddress: {
            id: publicIpId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'frontend-port-ssl'
        properties: {
          port: 443
        }
      }
    ]
    // Backend Address Pools - Container Apps + Investment (conditional)
    backendAddressPools: concat(containerAppBackendPools, investmentBackendPools)
    loadDistributionPolicies: []
    // Backend HTTP Settings - Container Apps + Investment (conditional)
    backendHttpSettingsCollection: concat(containerAppHttpSettings, investmentHttpSettings)
    backendSettingsCollection: []
    // HTTPS Listener with custom error configuration
    httpListeners: [
      {
        name: 'https-listener-frontend'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'agwaf-frontend-ip-config')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'frontend-port-ssl')
          }
          protocol: 'Https'
          sslCertificate: !empty(keyVaultCertificateSecretId) || !empty(sslCertificateData) ? {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', applicationGatewayName, 'front-end-cert')
          } : null
          hostNames: []
          requireServerNameIndication: false
          customErrorConfigurations: !empty(staticErrorPageUrl403) ? [
            {
              statusCode: 'HttpStatus403'
              customErrorPageUrl: staticErrorPageUrl403
            }
          ] : []
        }
      }
    ]
    listeners: []
    // URL Path Map - Path-based routing
    urlPathMaps: [
      {
        name: 'path-map'
        properties: {
          defaultBackendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'address-pool-chat_app_frontend-containerapp')
          }
          defaultBackendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'http-settings-chat_app_frontend-containerapp')
          }
          pathRules: concat(investmentPathRules, containerAppPathRules)
        }
      }
    ]
    // Path-based routing rule
    requestRoutingRules: [
      {
        name: 'app-front-end-request-routing-rule'
        properties: {
          ruleType: 'PathBasedRouting'
          priority: 9
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'https-listener-frontend')
          }
          urlPathMap: {
            id: resourceId('Microsoft.Network/applicationGateways/urlPathMaps', applicationGatewayName, 'path-map')
          }
        }
      }
    ]
    routingRules: []
    // Health Probes - Container Apps + Investment (conditional)
    probes: concat(containerAppProbes, investmentProbes)
    // Rewrite Rule Sets - URL rewriting and security headers
    rewriteRuleSets: [
      {
        name: 'uri-rewrite'
        properties: {
          rewriteRules: concat(investmentRewriteRules, securityHeaderRewriteRules, containerAppRewriteRules)
        }
      }
    ]
    redirectConfigurations: []
    privateLinkConfigurations: []
    enableHttp2: false
    customErrorConfigurations: []
    firewallPolicy: {
      id: wafPolicy.id
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

output wafPolicyId string = wafPolicy.id
output wafPolicyName string = wafPolicy.name
output applicationGatewayId string = appGateway.id
output applicationGatewayName string = appGateway.name
